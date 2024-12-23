import pandas as pd

# File paths for the CSVs
dataset_csv_path = "Experiments - Gemini 1.5 Flash.csv"  # Path to the first CSV
second_csv_path = "Outputs/gemini_baseline1_results.csv"  # Path to the second CSV
output_csv_path = "merged_dataset_baseline1.csv"  # Path for the output CSV

# Load both CSV files into DataFrames
dataset_df = pd.read_csv(dataset_csv_path)
second_df = pd.read_csv(second_csv_path)

# Deduplicate the second DataFrame to avoid multiple matches
second_df = second_df.drop_duplicates(subset=["input"])

# Perform a left merge to match `Query` with `input` and bring in the `response`
merged_df = dataset_df.merge(
    second_df[["input", "response"]],
    left_on="Query",  # Column in the first CSV
    right_on="input",  # Column in the second CSV
    how="left"  # Left join to preserve the rows in the first DataFrame
)

# Drop the redundant `input` column that came from the second CSV during the merge
merged_df = merged_df.drop(columns=["input"])

# Save the merged DataFrame to a new CSV file
merged_df.to_csv(output_csv_path, index=False)

print(f"Merged dataset with exactly {len(dataset_df)} rows has been saved to {output_csv_path}")