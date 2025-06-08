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

# Search for all encrypted files ending with .enc and decrypt them with kms
# Use the filename without the .enc suffix as the decrypted versions
cd "$CONTENT_ROOT" || exit
echo "Searching for encrypted .env files in $CONTENT_ROOT"

for encrypted_file in $(find . -name ".env*.enc" -type f); do
    # Get the original filename by removing the .enc extension
    original_file="${encrypted_file%.enc}"
    echo "Decrypting $encrypted_file to $original_file"
    
    gcloud kms decrypt \
        --location=$GCP_LOCATION \
        --keyring=$GCP_ENCRYPTION_KEYRING \
        --key=$GCP_ENCRYPTION_KEY \
        --ciphertext-file=$encrypted_file \
        --plaintext-file=$original_file \
        --project=$GCP_PROJECT
    
    if [ $? -eq 0 ]; then
        echo "Successfully decrypted $encrypted_file"
    else
        echo "Failed to decrypt $encrypted_file"
    fi
done

# Return to the original directory
cd "$CURRENT_DIR" || exit
echo "Decryption completed. Returned to $CURRENT_DIR"