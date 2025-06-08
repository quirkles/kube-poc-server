#!/bin/bash

# First check the directory that the script is being run from and set it to a variable
# we will reset back to this dir once the script is done
CURRENT_DIR=$(pwd)

# Second, get the directory that the script currently resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# remove the final /scripts in the directory fo the script to get to the content root
CONTENT_ROOT=${SCRIPT_DIR%/scripts}

GCP_ENCRYPTION_KEY=env_encryption
GCP_ENCRYPTION_KEYRING=encryption_keys
GCP_LOCATION=us-central1
GCP_PROJECT=quirkles-potw

# Search for all file beginning with .env and encrypt them with kms
# Use the filename suffixed with /enc as the encrypted versions
cd "$CONTENT_ROOT" || exit
echo "Searching for .env files in $CONTENT_ROOT"

for env_file in $(find . -name ".env*" -type f); do
    # Skip already encrypted files (those ending with .enc)
    if [[ "$env_file" == *".enc" ]]; then
        echo "Skipping already encrypted file: $env_file"
        continue
    fi
    
    encrypted_file="${env_file}.enc"
    echo "Encrypting $env_file to $encrypted_file"
    
    gcloud kms encrypt \
        --location=$GCP_LOCATION \
        --keyring=$GCP_ENCRYPTION_KEYRING \
        --key=$GCP_ENCRYPTION_KEY \
        --plaintext-file=$env_file \
        --ciphertext-file=$encrypted_file \
        --project=$GCP_PROJECT
    
    if [ $? -eq 0 ]; then
        echo "Successfully encrypted $env_file"
    else
        echo "Failed to encrypt $env_file"
    fi
done

# Return to the original directory
cd $CURRENT_DIR
echo "Encryption completed. Returned to $CURRENT_DIR"