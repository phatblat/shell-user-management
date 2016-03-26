#!/bin/bash -e

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
sudo dscl . -create /Groups/$group_name PrimaryGroupID $group_number
