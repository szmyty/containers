#!/usr/bin/env bash
# Script to generate a bcrypt hashed password for Portainer using htpasswd

# Ensure that exactly one argument is provided
if [[ $# -ne 1 ]]; then
    echo -e "\\nUsage: $0 <password>\\n"
    echo "Please provide a password as an argument."
    exit 1
fi

# Assign the provided password to a variable
password="$1"

# Generate bcrypt hash of the password for the user 'admin'
# and output only the hash part
bcrypt_hash=$(htpasswd -nbB admin "$password" | cut -d ":" -f 2)

# Output the generated bcrypt hash
echo "$bcrypt_hash"
