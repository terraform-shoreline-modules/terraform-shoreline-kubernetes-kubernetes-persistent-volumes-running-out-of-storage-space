

#!/bin/bash



# Get the name of the persistent volume that is running out of space

PV_NAME=${PV_NAME}



# Check the available space in the persistent volume

PV_CAPACITY=$(kubectl get pv $PV_NAME -o jsonpath='{.spec.capacity.storage}')



# Check the current usage of the persistent volume

PV_USAGE=$(kubectl get pv $PV_NAME -o jsonpath='{.status.capacity.storage}')



# Calculate the percentage of space used

PERCENTAGE_USED=$(echo "scale=2; ($PV_USAGE/$PV_CAPACITY)*100" | bc)



# Check if the percentage of space used has exceeded a threshold

THRESHOLD=80

if (( $(echo "$PERCENTAGE_USED > $THRESHOLD" | bc -l) )); then

  echo "The persistent volume $PV_NAME is running out of storage space."

  echo "Current capacity: $PV_CAPACITY"

  echo "Current usage: $PV_USAGE"

  echo "Percentage used: $PERCENTAGE_USED%"

else

  echo "The persistent volume $PV_NAME has sufficient storage space."

  echo "Current capacity: $PV_CAPACITY"

  echo "Current usage: $PV_USAGE"

  echo "Percentage used: $PERCENTAGE_USED%"

fi