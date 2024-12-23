import pandas as pd
import sqlglot
import re
import json
import difflib
import os
import numpy as np
from nltk.translate.bleu_score import sentence_bleu, SmoothingFunction
from collections import defaultdict

# Function to clean SQL queries (similar to the one in the post-processing script)
def clean_generated_sql(sql_query):
    if not isinstance(sql_query, str):
        return ""
    
    # Remove triple backticks and "sql" keyword at the start
    clean_sql = re.sub(r"^\"?```sql\s*", "", sql_query, flags=re.IGNORECASE)
    clean_sql = re.sub(r"```\"?$", "", clean_sql)
    
    # Remove unnecessary double quotes
    clean_sql = clean_sql.replace('""', "")
    
    # Trim whitespace
    clean_sql = clean_sql.strip()
    
    return clean_sql

# Function to load simplified schema (same as in the post-processing script)
def load_simplified_schema(dataset_type, db_id, schema_file_path=''):
    if dataset_type == 'BOOKSQL':
        json_file_path = './Schema_Prompt/SimplifiedST/booksql.txt'
    elif dataset_type == 'BIRD - dev':
        json_file_path = f'./Schema_Prompt/SimplifiedST/BIRD/{db_id}.json'
    elif dataset_type == 'Spider':
        json_file_path = f'./Schema_Prompt/SimplifiedST/Spider/{db_id}.json'
    elif dataset_type == 'Ambrosia':
        # Extract base directory and file name
        base_d = '/'.join(schema_file_path.split('/')[:2])  # Base directory
        file_parts = schema_file_path.split('/')[3:]  # Skip first 3 parts
        file = '/'.join(file_parts[:-1])  # Exclude last part (assumed to be file)
        json_file_name = f"{os.path.splitext(file)[0]}_dump.json"
        json_file_path = f"./Schema_Prompt/SimplifiedST/AMBROSIA/{base_d}/{json_file_name}"
    else:
        print(f"Unknown dataset type: {dataset_type}. Skipping row.")
        return [], []
    
    # Load table.column schema from the JSON file
    try:
        with open(json_file_path, 'r') as file:
            schema_data = json.load(file)
            columns = [f"{table.lower()}.{col.lower()}" for table, cols in schema_data.items() for col in cols]
            tables = [table.lower() for table in schema_data.keys()]
        return columns, tables
    except FileNotFoundError:
        print(f"File not found: {json_file_path}")
    except json.JSONDecodeError as e:
        print(f"JSON decode error: {e} in file {json_file_path}")
    except Exception as e:
        print(f"Error loading schema: {e} in file {json_file_path}")
    return [], []

# Normalize SQL queries using sqlglot
def normalize_sql(sql_query):
    try:
        # Parse the query
        parsed = sqlglot.parse_one(sql_query)
        # Normalize identifiers (lowercase)
        parsed = parsed.transform(lambda node: node.lower() if isinstance(node, sqlglot.expressions.Identifier) else node)
        # Remove aliases
        parsed = parsed.transform(lambda node: node.this if isinstance(node, sqlglot.expressions.Alias) else node)
        # Canonicalize the query
        normalized_sql = parsed.sql(dialect='ansi', pretty=False)
        return normalized_sql.lower()
    except Exception:
        return sql_query.lower().strip()

# Extract columns and tables from SQL query, mapping to schema
def extract_columns_and_tables(sql_query, schema_columns, schema_tables):
    try:
        parsed = sqlglot.parse_one(sql_query)
        # Extract table and column names
        tables = set()
        columns = set()
        for node in parsed.walk():
            if isinstance(node, sqlglot.expressions.Table):
                table_name = node.name.lower()
                if table_name not in schema_tables:
                    # Map to closest matching table name
                    matches = difflib.get_close_matches(table_name, schema_tables, n=1, cutoff=0.6)
                    if matches:
                        table_name = matches[0]
                tables.add(table_name)
            elif isinstance(node, sqlglot.expressions.Column):
                column_name = node.name.lower()
                if node.table:
                    table_name = node.table.lower()
                    full_column_name = f"{table_name}.{column_name}"
                    if full_column_name not in schema_columns:
                        # Map to closest matching column name
                        matches = difflib.get_close_matches(full_column_name, schema_columns, n=1, cutoff=0.6)
                        if matches:
                            full_column_name = matches[0]
                        else:
                            # Try mapping only the column name without table
                            schema_col_names = [col.split('.', 1)[1] for col in schema_columns]
                            matches = difflib.get_close_matches(column_name, schema_col_names, n=1, cutoff=0.6)
                            if matches:
                                full_column_name = f"{table_name}.{matches[0]}"
                    columns.add(full_column_name)
                else:
                    # Column without table
                    schema_col_names = [col.split('.', 1)[1] for col in schema_columns]
                    if column_name not in schema_col_names:
                        # Map to closest matching column name
                        matches = difflib.get_close_matches(column_name, schema_col_names, n=1, cutoff=0.6)
                        if matches:
                            column_name = matches[0]
                    columns.add(column_name)
        return columns, tables
    except Exception as e:
        return set(), set()

# Compute Precision, Recall, F1-Score
def compute_metrics(gold_set, generated_set):
    gold_set = sorted(gold_set)
    generated_set = sorted(generated_set)
    true_positives = len(gold_set & generated_set)
    precision = true_positives / len(generated_set) if generated_set else 0
    recall = true_positives / len(gold_set) if gold_set else 0
    f1_score = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
    return precision, recall, f1_score

# Function to check exact match
def is_exact_match(sql1, sql2):
    return sql1.strip() == sql2.strip()

# Load CSV file with corrected queries
csv_path = "Corrected_Queries.csv"  # The CSV file saved from the post-processing script
data = pd.read_csv(csv_path)

# Replace NaN or None values with empty strings in SQL columns
data.fillna('', inplace=True)

# Convert specific columns to string to avoid warnings
data.iloc[:, 6] = data.iloc[:, 6].astype(str)  # Gold SQL
data['Corrected_Generated_SQL'] = data['Corrected_Generated_SQL'].astype(str)  # Corrected Generated SQL

# Initialize metrics dictionaries
results = defaultdict(lambda: {'table_precision': [], 'table_recall': [], 'table_f1': [],
                               'column_precision': [], 'column_recall': [], 'column_f1': [],
                               'bleu_score': [], 'exact_match': []})

# Initialize the smoothing function for BLEU
smoothing_function = SmoothingFunction().method1

# Initialize schema cache
schema_cache = {}

for idx, row in data.iterrows():
    dataset_type = row.iloc[0]  # Dataset Type
    schema_file_path = ''  # Default empty string
    db_id = row.iloc[3]  # Database ID
    gold_sql = row.iloc[6]  # Gold SQL
    corrected_generated_sql = row['Corrected_Generated_SQL']  # Corrected Generated SQL

    # If dataset_type is Ambrosia, schema_file_path is required
    if dataset_type == 'Ambrosia':
        schema_file_path = row.iloc[3]  # Schema file path

    # Load schema columns and tables
    schema_key = f"{dataset_type}_{db_id}"
    if schema_key in schema_cache:
        schema_columns, schema_tables = schema_cache[schema_key]
    else:
        schema_columns, schema_tables = load_simplified_schema(dataset_type, db_id, schema_file_path)
        schema_cache[schema_key] = (schema_columns, schema_tables)

    if not schema_columns or not schema_tables:
        continue  # Skip if schema could not be loaded

    # Clean the gold SQL query
    gold_sql_cleaned = clean_generated_sql(gold_sql)
    # Optionally, correct the gold SQL (assuming it's correct)

    # Normalize both SQL queries
    generated_sql_normalized = normalize_sql(corrected_generated_sql)
    gold_sql_normalized = normalize_sql(gold_sql_cleaned)

    # Compute exact match
    exact_match = int(is_exact_match(generated_sql_normalized, gold_sql_normalized))
    results[dataset_type]['exact_match'].append(exact_match)

    # Extract columns and tables with mapping
    gold_columns, gold_tables = extract_columns_and_tables(gold_sql_normalized, schema_columns, schema_tables)
    generated_columns, generated_tables = extract_columns_and_tables(generated_sql_normalized, schema_columns, schema_tables)

    # Table Retrieval Metrics
    table_precision, table_recall, table_f1 = compute_metrics(gold_tables, generated_tables)
    results[dataset_type]['table_precision'].append(table_precision)
    results[dataset_type]['table_recall'].append(table_recall)
    results[dataset_type]['table_f1'].append(table_f1)

    # Column Retrieval Metrics
    column_precision, column_recall, column_f1 = compute_metrics(gold_columns, generated_columns)
    results[dataset_type]['column_precision'].append(column_precision)
    results[dataset_type]['column_recall'].append(column_recall)
    results[dataset_type]['column_f1'].append(column_f1)

    # BLEU Score with smoothing
    bleu_score = sentence_bleu([gold_sql_normalized.split()], generated_sql_normalized.split(), smoothing_function=smoothing_function)
    results[dataset_type]['bleu_score'].append(bleu_score)

# Compute averages for each dataset
final_results = {}
for dataset, metrics in results.items():
    final_results[dataset] = {
        'Table Retrieval - Precision': np.mean(metrics['table_precision']) if metrics['table_precision'] else 0,
        'Table Retrieval - Recall': np.mean(metrics['table_recall']) if metrics['table_recall'] else 0,
        'Table Retrieval - F1': np.mean(metrics['table_f1']) if metrics['table_f1'] else 0,
        'Column Retrieval - Precision': np.mean(metrics['column_precision']) if metrics['column_precision'] else 0,
        'Column Retrieval - Recall': np.mean(metrics['column_recall']) if metrics['column_recall'] else 0,
        'Column Retrieval - F1': np.mean(metrics['column_f1']) if metrics['column_f1'] else 0,
        'BLEU Score': np.mean(metrics['bleu_score']) if metrics['bleu_score'] else 0,
        'Exact Match': np.mean(metrics['exact_match']) if metrics['exact_match'] else 0,
    }

# Print final results
for dataset, metrics in final_results.items():
    print(f"Metrics for {dataset}:")
    for metric, value in metrics.items():
        print(f"  {metric}: {value:.4f}")
    print()
