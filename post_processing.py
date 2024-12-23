import pandas as pd
import sqlglot
import re
import json
import difflib
import os

def clean_generated_sql(sql_query):
    if not isinstance(sql_query, str):
        return ""
    
    # Remove triple backticks and "sql" keyword at the start
    clean_sql = re.sub(r"^\"?```sql\s*", "", sql_query, flags=re.IGNORECASE)
    clean_sql = re.sub(r"```\"?$", "", clean_sql)
    
    # Remove unnecessary double quotes
    clean_sql = clean_sql.replace('""', "")
    
    # Replace improperly escaped characters
    clean_sql = clean_sql.replace(r'\\', '')  # Remove escaped backslashes
    clean_sql = re.sub(r"''([^']+?)''", r"'\1'", clean_sql)  # Correct improperly quoted literals
    
    # Replace non-alphanumeric characters in identifiers (e.g., spaces, special chars)
    def sanitize_identifier(match):
        sanitized = match.group(1).replace(' ', '_').replace('-', '_')
        return sanitized.strip()
    
    clean_sql = re.sub(r'\[([^\]]+)\]', sanitize_identifier, clean_sql)
    
    # Ensure WHERE clause literals are quoted (e.g., Yes → 'Yes')
    clean_sql = re.sub(r'\b(Yes|No|Direct Charter)\b', r"'\1'", clean_sql)
    
    # Ensure dates are properly quoted
    clean_sql = re.sub(r'(\d{4}-\d{2}-\d{2})', r"'\1'", clean_sql)
    
    # Trim whitespace
    clean_sql = clean_sql.strip()
    
    return clean_sql

# Function to load simplified schema
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

def correct_sql_query(sql_query, schema_columns, schema_tables):
    try:
        # Attempt to parse the query
        parsed = sqlglot.parse_one(sql_query)
    except Exception as e:
        print(f"Error parsing SQL query: {e}")
        return sql_query  # Return the cleaned query as-is if parsing fails

    def replace_identifier(node):
        if isinstance(node, sqlglot.expressions.Table):
            table_name = node.name.lower()
            if table_name not in schema_tables:
                matches = difflib.get_close_matches(table_name, schema_tables, n=1, cutoff=0.6)
                if matches:
                    node.set('this', sqlglot.exp.to_identifier(matches[0]))
        elif isinstance(node, sqlglot.expressions.Column):
            column_name = node.name.lower()
            if node.table:
                table_name = node.table.lower()
                full_column_name = f"{table_name}.{column_name}"
                if full_column_name not in schema_columns:
                    if table_name not in schema_tables:
                        table_matches = difflib.get_close_matches(table_name, schema_tables, n=1, cutoff=0.6)
                        if table_matches:
                            node.set('table', sqlglot.exp.to_identifier(table_matches[0]))
                            table_name = table_matches[0]
                    full_column_name = f"{table_name}.{column_name}"
                    if full_column_name not in schema_columns:
                        schema_columns_in_table = [col.split('.', 1)[1] for col in schema_columns if col.startswith(f"{table_name}.")]
                        column_matches = difflib.get_close_matches(column_name, schema_columns_in_table, n=1, cutoff=0.6)
                        if column_matches:
                            node.set('this', sqlglot.exp.to_identifier(column_matches[0]))
            else:
                column_names = [col.split('.', 1)[1] for col in schema_columns]
                if column_name not in column_names:
                    column_matches = difflib.get_close_matches(column_name, column_names, n=1, cutoff=0.6)
                    if column_matches:
                        node.set('this', sqlglot.exp.to_identifier(column_matches[0]))
        return node

    try:
        # Transform the parsed query with schema corrections
        parsed = parsed.transform(replace_identifier)
        corrected_sql = parsed.sql()
        return corrected_sql
    except Exception as e:
        print(f"Error correcting SQL query: {e}")
        return sql_query  # Return the cleaned query on transformation failure

# Load CSV file
csv_path = "Experiments - Gemini 1.5 Flash.csv"  # Replace with your CSV file path
data = pd.read_csv(csv_path)
#data = data[]
gen_sql_num = 10

# Replace NaN values with empty strings
data.fillna('', inplace=True)

# Ensure the generated SQL column is of string type
data.iloc[:, gen_sql_num] = data.iloc[:, gen_sql_num].astype(str)  # Assuming column index gen_sql_num is the generated SQL

# Correct the generated queries and save them
corrected_queries = []

# Initialize schema cache to avoid loading the same schema multiple times
schema_cache = {}

for idx, row in data.iterrows():
    dataset_type = row.iloc[0]  # Dataset Type
    schema_file_path = ''  # Default empty string
    db_id = row.iloc[3]  # Database ID
    generated_sql = row.iloc[gen_sql_num]  # Generated SQL

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
        corrected_queries.append('')
        continue  # Skip if schema could not be loaded

    generated_sql_cleaned = clean_generated_sql(generated_sql)  # Clean the generated SQL
    corrected_generated_sql = correct_sql_query(generated_sql_cleaned, schema_columns, schema_tables)  # Correct the SQL
    corrected_queries.append(corrected_generated_sql)

# Add the corrected queries to the DataFrame
data['Corrected_Generated_SQL'] = corrected_queries

# Save the DataFrame to a new CSV file
output_csv_path = "Corrected_Queries.csv"
data.to_csv(output_csv_path, index=False)

print(f"Corrected SQL queries have been saved to {output_csv_path}")
