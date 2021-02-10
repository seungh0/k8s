# Pod

k8s에서의 최소 배포 단위

## Container

<img src="https://blog.kakaocdn.net/dn/pd7Ez/btqFA6OkwX9/8rAjO2yXqrDNOgiufrq6B1/img.png">

- 파드안에는 여러 컨테이너들이 있다. (1개 or n개)
- 파드 안의 각 컨테이너들은 각각 포트를 가지고 있으며, 파드 내의 컨테이너들은 한 호스트로 묶여있음.
- 이러한 이유로 같은 파드 내의 하나의 (A 컨테이너 - port:8000)에서 다른 컨테이너(B 컨테이너 - port:8001)로 localhost:8001로 접근할 수 있다.

- 또한 파드 생성시, 쿠버네티스 클러스터 내부에서만 파드에 접속할 수 있는 IP가 할당됨 (외부에서는 접속할 수 없음)
- 이 IP는 파드가 다시 생성되거나 하면 IP가 변경된다 (IP가 고정되지 않음)

## Label

- k8s의 모든 오브젝트에 라벨을 달 수 있음.
- 라벨을 다는 이유는 오브젝트들을 기능에 따라 구분할 수 있게 하기 위해서입니다.
  ex) production, dev, test 등등.

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  labels:
    env: dev
spec:
  containers:
    - name: ...
      image: ...

---
apiVersion: v1
kind: Pod
metadata:
  name: pod-2
  labels:
    env: prod
spec:
  containers:
    - name: ...
      image: ...
```

- 이 라벨들을 이용해서 아래와 같이 Service 특정 오브젝트들만을 위한 서비스를 만드는 등 이용될 수 있음.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: service-1
spec:
  selector:
    env: prod
  ports:
    - port: 9000
      targetPort: 8000
  type: NodePort
```

## Node Schedule

파드는 결국 여러 노드 중에 하나의 노드에 올라가져아 하는데, 이를 결정하는 방법은 두 가지 방법이 있다.

1. 노드를 직접 선택하는 방법

- 아래의 경우 kubernetes.io/hostname: docker-desktop 이라는 노드를 직접 선택하여서 파드를 띄움.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ...
spec:
  nodeSelector:
    kubernetes.io/hostname: docker-desktop
  containers:
    - name: ...
      image: ...
```

2. 쿠버네티스가 알아서 선택해주는 방법

- 아래의 경우 해당 스펙에 따라 k8s가 적절한 노드를 선택해서 파드를 띄워줌.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ...
spec:
  containers:
    - name: ...
      image: ...
      resources:
        requests:
          memory: 0.5Gi
        limits:
          memory: 0.5Gi
```
