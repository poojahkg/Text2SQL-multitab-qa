import json
import csv

def json_to_csv(json_file_path, csv_file_path):
    try:
        # Load JSON data
        with open(json_file_path, 'r', encoding='utf-8') as json_file:
            data = json.load(json_file)
        
        # Remove duplicates based on `data_point`
        if isinstance(data, list):
            unique_data = {}
            for item in data:
                if isinstance(item, dict) and 'data_point' in item:
                    # Overwrite if `data_point` is duplicate, keeping the latest entry
                    unique_data[item['data_point']] = item
            
            # Convert back to list
            data = list(unique_data.values())
        
        # Open the CSV file for writing
        with open(csv_file_path, 'w', encoding='utf-8', newline='') as csv_file:
            writer = csv.writer(csv_file)
            
            # If JSON data is a list of dictionaries
            if isinstance(data, list) and all(isinstance(item, dict) for item in data):
                # Extract headers from the first dictionary
                headers = data[0].keys()
                writer.writerow(headers)
                
                # Write data rows
                for row in data:
                    writer.writerow(row.values())
            else:
                print("JSON data is not in the expected format (list of dictionaries).")
    except Exception as e:
        print(f"Error: {str(e)}")

# Example usage
json_file_path = 'Outputs/gemini_step1_results_ambrosia.json'  # Path to the input JSON file
csv_file_path = 'Outputs/gemini_step1_results_ambrosia.csv'    # Path to the output CSV file
json_to_csv(json_file_path, csv_file_path)
print(f"Converted {json_file_path} to {csv_file_path}, with duplicates removed.")
