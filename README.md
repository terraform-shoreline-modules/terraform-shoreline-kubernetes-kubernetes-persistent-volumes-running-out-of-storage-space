
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes - Persistent Volumes Running Out of Storage Space.
---

This incident type refers to a situation where the persistent volumes used in a software application are running out of storage space. Persistent volumes are used to store data in a containerized environment, and if the storage space is limited, it can lead to errors and service disruptions. This issue can occur due to various reasons such as a sudden increase in data volume, incorrect configuration, or inefficient utilization of storage resources. It is crucial to monitor and manage the available storage space to ensure the smooth functioning of the software application.

### Parameters
```shell
export PV_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export PVC_NAME="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export NEW_SIZE="PLACEHOLDER"
```

## Debug

### List all persistent volumes in the cluster
```shell
kubectl get pv
```

### Check the usage and capacity of each persistent volume
```shell
kubectl describe pv ${PV_NAME}
```

### Check the usage and capacity of the persistent volume claim(s) that use the persistent volume
```shell
kubectl describe pvc -n ${NAMESPACE} ${PVC_NAME}
```

### Check the usage and capacity of the pod(s) that use the persistent volume claim(s)
```shell
kubectl describe pod -n ${NAMESPACE} ${POD_NAME}
```

### Check the logs of the pod(s) to see if there are any errors related to storage
```shell
kubectl logs -n ${NAMESPACE} ${POD_NAME}
```

### Check if there are any pending events related to storage in the cluster
```shell
kubectl get events
```

### Check if there are any nodes with low disk space available
```shell
kubectl describe node
```

### There might be a sudden increase in data volume that the persistent volume cannot handle.
```shell


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


```

## Repair

### Increase the storage capacity of the persistent volumes.
```shell


#!/bin/bash



# Set variables

PVC_NAME=${PVC_NAME} # Name of the persistent volume claim to modify

NEW_SIZE=${NEW_SIZE} # New size to set for the persistent volume claim



# Update the persistent volume claim with the new size

kubectl patch pvc $PVC_NAME -p '{"spec":{"resources":{"requests":{"storage":"'$NEW_SIZE'"}}}}'





./increase-pvc-size.sh --pvc-name my-pvc --new-size 10Gi


```