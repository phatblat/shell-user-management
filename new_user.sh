#!/bin/bash

#
# new_user.sh
# Creates a new unix user.
#

# User name is required
if [[ $# -ne 1 ]]; then
  echo "Usage: new_user.sh user_name"
  exit 1
fi
user_name=$1

# Secure password entry, stores in $password
stty -echo
read -p "Password for new user: " password; echo
stty echo

# Get a user ID value to be used when creating the new user
user_max_id=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
user_number=$((user_max_id+1))

echo "Creating a '$user_name' user with id = $user_number"
dscl . -create /Users/$user_name

error=$?
if [ $error -ne 0 ]; then
  echo ""
  echo "Your account does not have permission to create users. Rerun this script using sudo:"
  echo "  sudo ./new_user.sh $user_name"
  exit $error
fi

dscl . -create /Users/$user_name UserShell /bin/bash
dscl . -create /Users/$user_name RealName $user_name
dscl . -create /Users/$user_name UniqueID $usernumber
dscl . -create /Users/$user_name NFSHomeDirectory /Users/$user_name

# Replace with a real password
dscl . -passwd /Users/$user_name "$password"
dscl . -create /Users/$user_name PrimaryGroupID 20 # standard user, 80 for admin
dscl . -read /Users/$user_name

# Create the user's home directory plus the .ssh directory
mkdir -p /Users/$user_name/.ssh
chmod 0700 /Users/$user_name/.ssh
touch /Users/$user_name/.ssh/authorized_keys
chmod 600 /Users/$user_name/.ssh/authorized_keys
