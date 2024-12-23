import json
import re
import pandas as pd

# Load the JSON data
file_path = "dev-spider.json"  # Replace with your JSON file path
with open(file_path, 'r') as file:
    data = json.load(file)

# Process the data
rows = []
for item in data:
    db_id = item["db_id"]
    question = item["question"]
    sql_query = item["query"]

    # Find the highest T value in the SQL query
    table_refs = re.findall(r"T(\d+)", sql_query)
    num_tables = max(map(int, table_refs)) if table_refs else 1  # Default to 1 if no T references are found

    rows.append([db_id, question, sql_query, num_tables])

# Create a DataFrame
columns = ["db_id", "question", "SQL", "number of tables"]
df_3 = pd.DataFrame(rows, columns=columns)

# Save the DataFrame as a CSV file
output_path = "spider.csv"
df_3.to_csv(output_path, index=False)

print(f"The data has been saved to {output_path}.")
