---
title: Fix PHP/Apache Issue
linkTitle: Fix PHP/Apache Issue
weight: 4
---
## 1. Kubernetes Resources

Especially in Production Kubernetes Clusters, CPU and Memory are considered precious resources. And  the Cluster operators will normally require you to specify in the deployment the amount of CPU and Memory your Pod or Service will require, so they can have the Cluster automatically manage on which Node(s) your solution will be placed.

You do this by placing a Resource section in the deployment of you application/Pod

**Example:**

``` yaml
resources:
  limits:         # Maximum amount of CPU & memory for peek use
    cpu: "8"      # Maximum of 8 cores of CPU allowed at for peek use
    memory: "9Mi" # Maximum allowed 9Mb of memory
  requests:       # Request are the expected amount of CPU & memory for normal use
    cpu: "6"      # Requesting 4 cores of a CPU
    memory: "4Mi" # Requesting 4Mb of memory
```

More information can be found here : [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

If your application or Pod will go over the limits set in your deployment, Kubernetes will kill and restart your Pod to protect the other applications on the Cluster.

Another scenario that you will run into is when there is not enough Memory or CPU on a Node. In that case, the Cluster will try to reschedule your Pod(s) on a different Node with more space.

If that fails, or if there is not enough space when you deploy your application, the Cluster will put your workload/deployment in schedule mode until there is enough room on any of the available Nodes to deploy the Pods according their limits.

## 2. Fix PHP/Apache Deployment

{{% alert title="Workshop Question" color="success" %}}

Before we start, let's check the current status of the PHP/Apache deployment. Which Auto-Detect detector has fired & is there a change in the Analyzer?

{{% /alert %}}

To fix the PHP/Apache StatefulSet, edit the `YAML` you created and reduce the CPU resources further:

Find the resources section and reduce the CPU limits to **1** and the CPU requests to **0.5**:

``` yaml
resources:
  limits:
    cpu: "1"
    memory: "9Mi"
  requests:
    cpu: "0.5"
    memory: "4Mi"
```

Save the above changes. Now, we must delete the existing StatefulSet and re-create it:

``` bash
kubectl delete statefulset php-apache -n apache
```

``` bash
kubectl apply -f php-apache.yaml -n apache
```

## 3. Validate the changes

You can validate the changes have been applied by running the following command:

``` bash
kubectl describe statefulset php-apache -n apache
```

Validate the Pod is now running in Splunk Observability Cloud.

{{% alert title="Workshop Question" color="success" %}}
Is the **Apache Web Servers** dashboard showing any data now?

**Tip:** Don't forget to use filters and time frames to narrow down your data.
{{% /alert %}}

{{% alert title="Workshop Question" color="success" %}}
Another Auto-Detect Detector has fired, which one is it this time?
{{% /alert %}}

## 4. Fix memory issue

``` bash
kubectl edit statefulset php-apache -n apache
```

``` yaml
resources:
  limits:
    cpu: "1"
    memory: "16Mi"
  requests:
    cpu: "0.5"
    memory: "12Mi"
```

``` bash
kubectl delete pod php-apache-0 -n apache
```

Validate the changes have been applied by running the following command:

``` bash
kubectl describe statefulset php-apache -n apache
```
