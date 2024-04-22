#!/bin/bash
# Define Variables for namespace, deployment name, and maximum number of restarts.
NAMESPACE="sre"
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=3

# Start a Loop.
while true; do
    # Check Pod Restarts (using the kubectl get pods command to retrieve the number of restarts of the pod associated with the specified deployment in the specified namespace).
    RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT_NAME} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
    # Display Restart Count to the console.
    echo "Current restart count: ${RESTARTS}"
    # Check Restart Limit by comparing the current number of restarts with the maximum number of restarts.
    if (( RESTARTS > MAX_RESTARTS )); then
        # Scale Down if the number of restarts is greater than the maximum allowed, print a message to the console, scale down the deployment to zero replicas using the kubectl scale command, and break the loop.
        echo "Exceeded maximum number of restarts. Scaling down deployment..."
        kubectl scale --replicas=0 deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE}
        break
    else
        # Pause if the number of restarts is not greater than the maximum allowed, pause the script for 60 seconds before the next check.
        sleep 60
    fi
    # Repeat indefinitely until the number of restarts exceeds the maximum allowed, at which point the deployment is scaled down and the loop is broken.
done
