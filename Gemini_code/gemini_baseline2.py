import os
import json
import pandas as pd
import time
from datetime import datetime
import google.generativeai as genai

class GeminiBot:
    def __init__(self, api_key=None, model_name="gemini-1.5-flash",
                 data_path=None, txt_file_path=None, json_file_path=None, limit_rows=None, output_path=None):
        # Initialize API key
        self.api_key = api_key
        if not self.api_key:
            raise ValueError("API key is required. Set it in the constructor or as an environment variable 'GOOGLE_AI_API_KEY'")

        # Configure the generative AI
        genai.configure(api_key=self.api_key)
        self.limit_rows = limit_rows
        self.output_path = output_path  # Use consistent output path
        self.txt_file_path = txt_file_path
        self.json_file_path = json_file_path
        self.model_name = model_name
        self.data_path = data_path

        # Set up generation configuration
        self.generation_config = {
            "temperature": 1,
            "top_p": 0.95,
            "top_k": 40,
            "max_output_tokens": 8192,
            "response_mime_type": "text/plain",
        }

        # Create model and chat session
        self.model = self._create_model()
        self.chat_session = self.model.start_chat(history=[])

    def _create_model(self):
        return genai.GenerativeModel(
            model_name=self.model_name,
            generation_config=self.generation_config,
        )

    def get_response(self, user_message):
        try:
            response = self.chat_session.send_message(user_message)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"

    def load_prompt(self):
        try:
            # Try reading with UTF-8 encoding
            with open(self.txt_file_path, 'r', encoding='utf-8') as file:
                return file.read().strip()
        except UnicodeDecodeError:
            print(f"UTF-8 decoding failed for {self.txt_file_path}. Trying ISO-8859-1...")
            try:
                # Fallback to ISO-8859-1 encoding
                with open(self.txt_file_path, 'r', encoding='ISO-8859-1') as file:
                    return file.read().strip()
            except Exception as e:
                print(f"Error reading prompt file with fallback encoding: {str(e)}")
                return ""
        except FileNotFoundError:
            print(f"Prompt file not found at {self.txt_file_path}")
            return ""
        except Exception as e:
            print(f"Error reading prompt file: {str(e)}")
            return ""


    def load_schema(self):
        try:
            # Try reading with UTF-8 encoding
            with open(self.json_file_path, 'r', encoding='utf-8') as file:
                return file.read()
        except UnicodeDecodeError:
            print(f"UTF-8 decoding failed for {self.json_file_path}. Trying ISO-8859-1...")
            try:
                # Fallback to ISO-8859-1 encoding
                with open(self.json_file_path, 'r', encoding='ISO-8859-1') as file:
                    return file.read()
            except Exception as e:
                print(f"Error reading schema file with fallback encoding: {str(e)}")
                return ""
        except FileNotFoundError:
            print(f"Schema file not found at {self.json_file_path}")
            return ""
        except Exception as e:
            print(f"Error reading schema file: {str(e)}")
            return ""

    def run_inference(self, data_points, evidence):
        print("Starting inference...")
        prompt = self.load_prompt()
        schema = self.load_schema()

        if not prompt or not schema:
            print("Prompt or schema not loaded. Exiting.")
            return

        # Load existing results if the file exists
        try:
            if os.path.exists(self.output_path):
                with open(self.output_path, 'r') as file:
                    results = json.load(file)
            else:
                results = []
        except Exception as e:
            print(f"Error reading existing results: {e}")
            results = []

        # Track processed data points
        processed_points = {result['data_point'] for result in results}

        # Start from the next data point
        next_data_point = max(processed_points, default=0) + 1

        for i, point in enumerate(data_points, next_data_point):  # Start from next_data_point
            if i in processed_points:
                print(f"Skipping already processed data point {i}")
                continue

            if i % 150 == 0:  # Rate limiting
                time.sleep(10)
            if self.limit_rows is not None and i > self.limit_rows:
                break

            message = f"{prompt}:\n Simplified Schema: {schema}:\n Question{point} \n Hint/evidence: {evidence}"
            try:
                response = self.get_response(message)
                result = {'data_point': i, 'input': point, 'response': response}
                results.append(result)

                # Save to JSON file after processing each point
                with open(self.output_path, "w") as json_file:
                    json.dump(results, json_file, indent=2)

                print(f"Data point {i} processed.")
            except Exception as e:
                print(f"Error processing data point {i}: {e}")
                continue

        return results


# Main function to handle dataset and logic
def process_dataset(dataframe, api_key, model_name, output_path, limit_rows=None):
    all_results = []
    for index, row in dataframe.iterrows():
        dataset_type = row.iloc[0]
        db_id = row.iloc[3]
        query = row.iloc[4]
        evidence = row.iloc[5]

        # Determine paths based on dataset type
        if dataset_type == 'BIRD - dev':
            txt_file_path = f'../Schema_Prompt/SimplifiedST/prompt_baseline2.txt'
            json_file_path = f'../Schema_Prompt/SimplifiedST/BIRD/{db_id}.txt'
        elif dataset_type == 'Spider':
            txt_file_path = f'../Schema_Prompt/SimplifiedST/prompt_baseline2.txt'
            json_file_path = f'../Schema_Prompt/SimplifiedST/Spider/{db_id}.txt'
        elif dataset_type == 'Ambrosia':
            txt_file_path = f'./Schema_Prompt/SimplifiedST/prompt_baseline2.txt'
            schema_file_path = row.iloc[3]
            base_d = '/'.join(schema_file_path.split('/')[:2])  # Base directory
            file =  '/'.join(schema_file_path.split('/')[3:-1])  # Base directory
            #print("#######")
            json_file_name = f"{os.path.splitext(file)[0]}_dump.json"  # Change .sql to .json
            json_file_path = f"./Schema_Prompt/SimplifiedST/AMBROSIA/{base_d}/{json_file_name}"  # Full path to the .json file
            #print(json_file_path)
            #break
        else:
            print(f"Unknown dataset type: {dataset_type}. Skipping row {index}.")
            continue

        # Initialize bot with specific file paths
        bot = GeminiBot(
            api_key=api_key,
            model_name=model_name,
            txt_file_path=txt_file_path,
            json_file_path=json_file_path,
            data_path=None,
            limit_rows=limit_rows,
            output_path=output_path
        )

        # Run inference for the current query
        results = bot.run_inference([query], evidence)
        all_results.extend(results)

    # Save all results to a single JSON file at the end
    with open(output_path, "w") as json_file:
        json.dump(all_results, json_file, indent=2)

    print(f"All results have been saved to {output_path}.")
    return all_results

# Load the CSV file
csv_file_path = 'Experiments - Gemini 1.5 Flash.csv'  # Replace with the actual file path
df = pd.read_csv(csv_file_path)

# Set your API key
api_key = ""  # Replace with your actual API key

# Define output paths
output_json_path = "./Outputs/gemini_baseline2_results.json"  # Path to save the responses

# Process the dataset
results = process_dataset(
    dataframe=df[:1043],
    api_key=api_key,
    model_name="gemini-1.5-flash",
    output_path=output_json_path,
    limit_rows=None  # Process all rows
)
