# ReplicaSet, Replication Controller(Deprecated)

Replication은 Pod의 Label과 Replication의 Selector를 통해 파드에 연결할 수 있다.

## Template

- Template에 파드의 내용을 넣게 되는데, 컨트롤러는 파드에 이상이 생기면 재생성 시키는 역할을 한다.
  이때 파드가 다운되면, Template을 통해 파드를 생성한다.

- 이러한 특징을 통해 버전 업그레이드시 Template에 Pod:v2로 업그레이드 후, 기존의 파드를 다운시키면 컨트롤러는 Template을 가지고 파드를 재 생성한다. => 버전 업그레이드

## Replicas

- 파드의 갯수를 관리 & 유지

- 예를 들어 Replicas: 3이면, 파드의 갯수를 3개로 유지한다.
  (이때 Replicas의 수를 줄이면 Scalling Out, 늘리면 Scalling In 된다.)

## Template + Replicas을 통한 Replicaset의 기능

- Template + Replicas을 이용해 파드 없이 컨트롤러만 만들면, 컨트롤러는 Replicas의 수 만큼 Template에 있는 파드의 내용을 까지고 그 갯수만큼 파드를 생성한다.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rep-1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: pod
  template:
    metadata:
      name: pod-1
      labels:
        app: pod
    spec:
      containers:
        - name: container
          image: ...
```

## Selector

- Template, Replicas와는 다르게 ReplicaSet에만 있는 내용 (Replication Controller에는 없음)
- Replication Controller의 경우 Selector는 라벨이 key:value와 같은 파드들만 연결을 해준다. (key, value 중 하나라도 다르면 연결을 하지 않음)

- 하지만 ReplicaSet의 기능인 Selector를 이용하면 좀 더 유연하게 사용할 수 있다.
- Selector에는 두 가지 속성이 존재한다.

  - MatchLabels
    - 기존의 Selector와 같이 key, value가 모두 같아야만 연결을 한다.
  - MatchExpressions

    컨트롤러는 좀 더 자세히 컨트롤 할 수 있음.

    - Exists: key가 일치한 파드들을 연결. ex) key: A
    - DoesNotExist: key가 일치하지 않은 파드들을 연결. ex) key: A
    - In: 해당 key + values에 포함된 파드들을 연결 ex) key: A, values: 2,3
    - NotIn: In에 반대 개념

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: replicaset-1
spec:
  replicas: 2
  selector:
    matchExpressions:
      - { key: app, operator: In, values: [pod] }
      - { key: ver, operator: Exists }
  template:
    metadata:
      name: pod-1
      labels:
        app: pod
        ver: v2
    spec:
      containers:
        - name: container
          image: ...
```
