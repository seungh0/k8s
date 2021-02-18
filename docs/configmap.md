# ConfigMap, Secret의 필요성

- 환경마다 설정 값을 다르게 줘야하는 경우
- 컨테이너 안의 서비스 이미지에 값을 다르게 준다는 것은 개발환경과 프로덕션 환경에 컨테이너 이미지를 각각 관리하겠다라는 의미 => 값 몇개 때문에 큰 용량의 이미지를 별도로 관리한다는 것은 부담되는 일임.

- 보통 환경에 따라 변하는 값들은 외부에서 결정을 할 수 있도록 해줌 => 그걸 도와주는 것이 ConfigMap과 Secret임.

- 분리해야할 상수들을 모아서 ConfigMap을 만들고 키와 같이 보안적인 관리적인 값들을 모아서 Secret을 만듬.
- 파드 생성시에 두 ConfigMap, Secret 오브젝트를 연결할 수 있는데, 연결하게 되면 컨테이너의 환경 변수에 이 데이터들이 들어가진다.

# ConfigMap, Secret의 종류

데이터로 Literal(상수)를 넣을 수 있고, 파일을 넣을 수 있고, 볼륨을 마운트 하는 파일을 넣을 수 있음.

## Env (Literal)

- ConfigMap은 key, value 로 구성 되어 있음.
- 파드를 생성할 떄 ConfigMap을 가져와서 컨테이너 안의 환경 변수에 설정할 수 있음.
- Secret은 보안적인 요소에 대한 값들을 저장하는데 사용함. (값을 Base64로 변경해서 넣어야되고, 파드에 넣을때 디코딩 되서 주입됨)
- Secret의 경우 메모리에 저장된다. (파일에 저장되는 것보다 보안상 유리)
- ConfigMap의 경우 key, value 리스트를 무한대로 넣을 수 있는 반면에, Secret의 경우 1MB만 넣을 수 있음.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cm-dev
data:
  SSH: "false"
  User: dev

---
apiVersion: v1
kind: Secret
metadata:
  name: sec-dev
data:
  key: MTlzNA==

---
apiVersion: v1
kind: Pod
metadata:
  name: pod-1
spec:
  containers:
    - name: container
      image: ghcr.io/seungh0/k8s-study
      envFrom:
        - configMapRef:
            name: cm-dev
        - secretRef:
            name: sec-dev
```

## Env (File)

- configMap의 값이 변해도, 컨테이너에 영향이 없음

  ```bash
  echo "ConfigMap" >> file-c.txt

  kubectl create configmap cm-file --from-file=./file-c.txt
  ```

  ```bash
  echo "Secret" >> file-s.txt

  kubectl create secret generic sec-file --from-file=./file-s.txt
  ```

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  name: pod-configmap-secret
  spec:
  containers:
    - name: container
      image: ghcr.io/seungh0/k8s-study:latest
      env:
        - name: file-c
          valueFrom:
            configMapKeyRef:
              name: cm-file
              key: file-c.txt
        - name: file-s
          valueFrom:
            secretKeyRef:
              name: sec-file
              key: file-s.txt
  ```

## Env (Volume Mount File)

- configMap의 값이 변하면, 파드에 마운팅 된 값도 변경이 됨.

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  name: pod-mount
  spec:
  containers:
      - name: container
      image: ghcr.io/seungh0/k8s-study
      volumeMounts:
          - name: file-volume
          mountPath: /mount
  volumes:
      - name: file-volume
      configMap:
          name: cm-file
  ```
