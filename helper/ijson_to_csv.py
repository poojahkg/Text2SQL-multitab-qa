import ijson
import csv
import os

def json_to_csv_stream(json_file_path, csv_file_path):
    try:
        if not os.path.exists(json_file_path):
            print(f"Error: JSON file not found at {json_file_path}")
            return
        
        print("Streaming JSON file incrementally...")
        unique_data = {}

        # Stream JSON data incrementally
        with open(json_file_path, 'r', encoding='utf-8') as json_file:
            try:
                # Assume the JSON file is an array of objects
                parser = ijson.items(json_file, 'item')  # Stream objects from the array
                for item in parser:
                    if isinstance(item, dict) and 'data_point' in item:
                        unique_data[item['data_point']] = item
                    else:
                        print(f"Warning: Skipping invalid item: {item}")
            except ijson.common.IncompleteJSONError:
                print("Warning: Incomplete JSON detected. Attempting to process what can be parsed.")

        unique_data_list = list(unique_data.values())
        if not unique_data_list:
            print("No valid data found after parsing. Please check the JSON file.")
            return

        print(f"After removing duplicates, {len(unique_data_list)} entries remain.")

        # Ensure output directory exists
        os.makedirs(os.path.dirname(csv_file_path), exist_ok=True)

        # Write the processed data to a CSV file
        print("Writing data to CSV file...")
        with open(csv_file_path, 'w', encoding='utf-8', newline='') as csv_file:
            writer = csv.writer(csv_file)
            headers = unique_data_list[0].keys()
            writer.writerow(headers)
            for row in unique_data_list:
                writer.writerow(row.values())

        print(f"Converted {json_file_path} to {csv_file_path}, with duplicates removed.")

    except Exception as e:
        print("An error occurred:")
        import traceback
        traceback.print_exc()

# Example usage
json_file_path = './Outputs/gemini_step2_results_ambrosia.json'  # Path to the input JSON file
csv_file_path = './Outputs/gemini_step2_results_ambrosia.csv'    # Path to the output CSV file

json_to_csv_stream(json_file_path, csv_file_path)
