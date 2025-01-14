import os
import pandas as pd

# Directory containing the year-wise folders
base_directory = "C:\\Praveen\\learnings\\DataAnalysts\\DataAnalystProjects\\PhonePePulse_DataAnalysis\\pulse-master\\data\\aggregated\\insurance\\country\\india"  # List to store dataframes
all_data = []

# Traverse through year-wise folders
for year_folder in os.listdir(base_directory):
    year_path = os.path.join(base_directory, year_folder)

    # Check if the folder name is a year (e.g., "2023", "2024")
    if os.path.isdir(year_path) and year_folder.isdigit():
        year = int(year_folder)

        # Traverse through quarter files in the year folder
        for quarter_file in os.listdir(year_path):
            if quarter_file.endswith(".json"):
                quarter = "Q" + quarter_file.replace(".json", "")  # Extract quarter (e.g., "Q1")
                file_path = os.path.join(year_path, quarter_file)
                folder_name = ['insurance', 'transaction', 'user']

                # Read JSON files
                if folder_name[0] in base_directory.split(os.sep):  # Read insurance folder
                    df_data = pd.read_json(file_path)
                    df = df_data["data"]["transactionData"]
                    # Flatten the data for analysis
                    flattened_data = []
                    for transaction in df:
                        for instrument in transaction["paymentInstruments"]:
                            flattened_data.append({
                                "name": transaction["name"],
                                "type": instrument["type"],
                                "count": instrument["count"],
                                "amount": instrument["amount"]
                            })
                    # Convert to a Pandas DataFrame
                    df = pd.DataFrame(flattened_data)
                    # Add year and quarter columns
                    df["year"] = year
                    df["quarter"] = quarter
                    # Append to the list
                    all_data.append(df)

                elif folder_name[1] in base_directory.split(os.sep):  # Read transaction folder
                    df_data = pd.read_json(file_path)
                    df = df_data["data"]["transactionData"]
                    # Flatten the data for analysis
                    flattened_data = []
                    for transaction in df:
                        for instrument in transaction["paymentInstruments"]:
                            flattened_data.append({
                                "name": transaction["name"],
                                "type": instrument["type"],
                                "count": instrument["count"],
                                "amount": instrument["amount"]
                            })
                    # Convert to a Pandas DataFrame
                    df = pd.DataFrame(flattened_data)
                    # Add year and quarter columns
                    df["year"] = year
                    df["quarter"] = quarter
                    # Append to the list
                    all_data.append(df)

                elif folder_name[2] in base_directory.split(os.sep): # Read user folder
                    df_data = pd.read_json(file_path)
                    df = df_data["data"]["usersByDevice"]
                    # Convert to a Pandas DataFrame
                    df = pd.DataFrame(df)
                    # Add year and quarter columns
                    df["year"] = year
                    df["quarter"] = quarter
                    # Append to the list
                    all_data.append(df)
                else:
                    print("Json folder/files path not found")

# Combine all dataframes into one
final_df = pd.concat(all_data, ignore_index=True)

# Display the combined dataframe
print(final_df.head())

# Save data to csv file
output_path = "C:\\Praveen\\learnings\\DataAnalysts\\DataAnalystProjects\\PhonePePulse_DataAnalysis\\pulse-master\\data\\aggregated\\csv_files\\india_insurance.csv"
final_df.to_csv(output_path, index=False)
