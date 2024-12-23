#!/bin/bash

# Define the new database name
NEW_DB="ambrosia.db"

# Remove the new database if it already exists
if [ -f "$NEW_DB" ]; then
    echo "Removing existing database $NEW_DB"
    rm "$NEW_DB"
fi

# Create an empty SQLite database
echo "Creating new SQLite database: $NEW_DB"
sqlite3 "$NEW_DB" "AMBROSIA;"

# Find all .sqlite files in the current directory and subdirectories
SQLITE_FILES=$(find . -type f -name "*.sqlite")

# Loop through each .sqlite file
for FILE in $SQLITE_FILES; do
    echo "Processing $FILE"

    # Check if the file is a valid SQLite database
    if sqlite3 "$FILE" "PRAGMA integrity_check;" | grep -q "ok"; then
        echo "$FILE is a valid SQLite database. Dumping data..."
        
        # Dump the source database
        sqlite3 "$FILE" .dump > temp_dump.sql

        # Import into the new database
        sqlite3 "$NEW_DB" < temp_dump.sql
        if [ $? -eq 0 ]; then
            echo "Successfully merged $FILE into $NEW_DB."
        else
            echo "Error merging $FILE. Continuing with the next file."
        fi

        # Clean up the temporary dump file
        rm temp_dump.sql
    else
        echo "$FILE is not a valid SQLite database. Skipping."
    fi
done

echo "All databases merged into $NEW_DB."
