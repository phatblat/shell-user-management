#!/bin/bash

#
# new_group.sh
# Creates a new unix group.
#

# Group name is required
if [[ $# -ne 1 ]]; then
  echo "Usage: new_group.sh group_name"
  exit 1
fi
group_name=$1

# Get a Group ID value to be used when creating the new group
group_max_id=$(dscl . -list /Groups PrimaryGroupID | awk '{print $2}' | sort -ug | tail -1)
group_number=$((group_max_id+1))

# Create the Group
echo "Creating Group '$group_name' with group id = $group_number"
#echo "Enter your user password for sudo."
dscl . -create /Groups/$group_name PrimaryGroupID $group_number

error=$?
if [ $error -ne 0 ]; then
  echo ""
  echo "Your account does not have permission to create groups. Rerun this script using sudo:"
  echo "  sudo ./new_group.sh $group_name"
  exit $error
fi

dscl . -read /Groups/$group_name
