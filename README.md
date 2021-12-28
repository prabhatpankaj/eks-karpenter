# cloudgeeks.ca

##### https://www.youtube.com/c/AWSLinuxWindows

### Backend ###
##### S3


##### Create S3 Bucket with Versioning enabled

```console

aws s3api create-bucket --bucket cloudgeeks-terraform --region us-east-1

aws s3api put-bucket-versioning --bucket cloudgeeks-terraform --versioning-configuration Status=Enabled

```

##### Key Pair

```console
if [ -d /root/.ssh ]
then
echo "/root/.ssh exists"
else
mkdir -p /root/.ssh
fi

if [ -f /root/.ssh/*.pem ]
then
echo "pem is there, I am removing it"
rm -f ~/.ssh/*.pem
export SSH_KEY_NAME="terraform-cloudgeeks-eks"
aws ec2 create-key-pair --key-name "${SSH_KEY_NAME}" --query 'KeyMaterial' --output text > ~/.ssh/${SSH_KEY_NAME}.pem
else
echo "All is well, now I am creating fresh PEM"
export SSH_KEY_NAME="terraform-cloudgeeks"
aws ec2 create-key-pair --key-name "${SSH_KEY_NAME}" --query 'KeyMaterial' --output text > ~/.ssh/${SSH_KEY_NAME}.pem
fi
```

##### KubeConfig
```console
if [ -d /root/.kube ]
then
echo "/root.kube directory exists"
else
mkdir /root/.kube && touch /root/.kube/config
fi
```

##### Source

```console
source EKS.env

```

##### Metrics Server Installation
```console
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

##### Metrics-server
```console
kubectl get deployment metrics-server -n kube-system

kubectl get pods -n kube-system -l k8s-app=metrics-server
```

##### Load Testing

1. To create a php-apache deployment, run the following command:
```console
kubectl create deployment php-apache --image=k8s.gcr.io/hpa-example
```

2.    To set the CPU requests, run the following command:
```console
kubectl patch deployment php-apache -p='{"spec":{"template":{"spec":{"containers":[{"name":"hpa-example","resources":{"requests":{"cpu":"200m"}}}]}}}}'
```

3.    To expose the deployment as a service, run the following command:
```console
kubectl create service clusterip php-apache --tcp=80
```

4.    To create an HPA, run the following command:
```console
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
```

5.    To confirm that the HPA was created, run the following command:
```console
kubectl get hpa
```

6.    To create a pod to connect to the deployment that you created earlier, run the following command:
```console
kubectl run --generator=run-pod/v1 -i --tty load-generator --image=busybox /bin/sh
```

7.    To test a load on the pod in the namespace that you used in step 1, run the following script:
```console
while true; do wget -q -O- http://php-apache; done
```

8.    To see how the HPA scales the pod based on CPU utilization metrics, run the following command (preferably from another terminal window)
```console
kubectl get hpa -w
```

9. To clean up the resources used for testing the HPA, run the following commands:
```console
kubectl delete hpa,service,deployment php-apache
kubectl delete pod load-generator
```
