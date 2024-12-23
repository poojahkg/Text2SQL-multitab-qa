import os
import json
from datetime import datetime

# Function to create individual prompt files for schemas
def generate_prompt_files(reference_prompt_path, additional_instructions, schemas_folder, output_folder):
    """
    Generate prompt text files for each database schema based on a reference prompt.

    Args:
    - reference_prompt_path (str): Path to the reference prompt file.
    - additional_instructions (str): Additional instructions to include in the prompts.
    - schemas_folder (str): Path to the folder containing JSON schema files.
    - output_folder (str): Path to the folder where prompt text files will be saved.

    Returns:
    - None
    """
    # Load the reference prompt
    try:
        with open(reference_prompt_path, 'r') as ref_file:
            reference_prompt = ref_file.read().strip()
    except FileNotFoundError:
        print(f"Reference prompt file not found at {reference_prompt_path}.")
        return
    except Exception as e:
        print(f"Error loading reference prompt: {str(e)}")
        return

    # Ensure output folder exists
    os.makedirs(output_folder, exist_ok=True)

    # Process each schema JSON file
    for schema_file in os.listdir(schemas_folder):
        if schema_file.endswith('.json'):
            schema_path = os.path.join(schemas_folder, schema_file)

            # Load the schema content
            try:
                with open(schema_path, 'r') as schema_file_obj:
                    schema_content = json.load(schema_file_obj)
            except Exception as e:
                print(f"Error loading schema file {schema_file}: {str(e)}")
                continue

            # Generate the prompt
            prompt = (
                f"{reference_prompt}\n\n"
                f"### Additional Instructions ###\n"
                f"{additional_instructions}\n\n"
                f"### Database Schema ###\n"
                f"{json.dumps(schema_content, indent=2)}\n"
            )

            # Save the prompt to a new text file
            schema_name = os.path.splitext(schema_file)[0]
            output_file_path = os.path.join(output_folder, f"{schema_name}_prompt.txt")

            try:
                with open(output_file_path, 'w') as output_file:
                    output_file.write(prompt)
                print(f"Generated prompt file: {output_file_path}")
            except Exception as e:
                print(f"Error saving prompt file for {schema_name}: {str(e)}")


# Example usage
reference_prompt_path = "/path/to/reference_prompt.txt"  # Path to reference prompt
additional_instructions = "Ensure the SQL queries generated are optimized for performance and include explanations."
schemas_folder = "/path/to/schemas_folder"  # Folder containing 11 schema JSON files
output_folder = "/path/to/output_prompts"  # Folder to save generated prompt text files

# Generate prompts
generate_prompt_files(reference_prompt_path, additional_instructions, schemas_folder, output_folder)
