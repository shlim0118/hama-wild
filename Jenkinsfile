##### wild-deployment and service
apiVersion: v1
kind: Service
metadata:
  name: wild-service
  namespace: default
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
spec:
  selector:
    app: wild
  ports:
    - protocol: TCP
      port: 30003
      targetPort: 30003
  type: LoadBalancer

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wild-deployment
  namespace: default
  labels:
    app: wild
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wild
  template:
    metadata:
      labels:
        app: wild
    spec:
      tolerations:
      - key: "key"
        operator: "Equal"
        value: "geeks"
        effect: "NoSchedule"
      containers:
      - name: wild-container
        image: 756266714368.dkr.ecr.ap-northeast-2.amazonaws.com/wild:3
        ports:
        - containerPort: 30003     # wild server port
