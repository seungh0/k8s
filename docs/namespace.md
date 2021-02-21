# Namespace

용도에 따라 컨테이너와 리소스를 구분지어 관리할 수 있는, 일종의 논리적인 그룹. (리소스를 논리적으로 구분)

## Namespace의 활용

- 사용 목적에 따라 포드, 서비스 등의 리소스들을 격리함으로써 편리하게 구분할 수 있음.
- ResourceQuota 오브젝트를 이용해 특정 네임스페이스에서 생성되는 포드의 자원 사용량을 제한할 수 있음.

---

#### Namespace 생성

```
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

---

#### Namespace 사용

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  namespace: production # production namespace에 파드 생성
  labels:
    app: pod
spec:
  containers:
    - name: container
      image: seungh0/k8s-study
      ports:
        - containerPort: 8000
```
