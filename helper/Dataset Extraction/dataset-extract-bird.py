import json
import pandas as pd
import re
from tabulate import tabulate

# Load the JSON data
file_path = "dev-bird.json"  # Replace with your JSON file path
with open(file_path, 'r') as file:
    data = json.load(file)

# Process the data
rows = []
for item in data:
    db_id = item["db_id"]
    question = item["question"]
    evidence = item["evidence"]
    sql = item["SQL"]
    difficulty = item["difficulty"]

    # Find the highest T value in the SQL query
    table_refs = re.findall(r"T(\d+)", sql)
    num_tables = max(map(int, table_refs)) if table_refs else 1  # Default to 1 if no T references are found

    rows.append([db_id, question, evidence, sql, difficulty, num_tables])

# Create a DataFrame
columns = ["db_id", "question", "evidence", "SQL", "difficulty", "number of tables"]
df = pd.DataFrame(rows, columns=columns)

# Save the DataFrame as a CSV file
output_path = "bird.csv"
df.to_csv(output_path, index=False)

print(f"The data has been saved to {output_path}.")