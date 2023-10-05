

#!/bin/bash



# Set variables

PVC_NAME=${PVC_NAME} # Name of the persistent volume claim to modify

NEW_SIZE=${NEW_SIZE} # New size to set for the persistent volume claim



# Update the persistent volume claim with the new size

kubectl patch pvc $PVC_NAME -p '{"spec":{"resources":{"requests":{"storage":"'$NEW_SIZE'"}}}}'





./increase-pvc-size.sh --pvc-name my-pvc --new-size 10Gi