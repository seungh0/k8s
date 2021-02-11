# Volume

## emptyDir

- 파드 단위로 마운트되는 볼륨
- 같은 파드내의 컨테이너들끼리 데이터를 공유
- 파드 내의 마운트된 볼륨을 통해서 자신의 로컬처럼 데이터를 공유할 수 있음.
- 하지만, 파드 생성시 만들어지고 파드 삭제시 없어지므로 일시적인 데이터를 보관해야 한다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-volume-1
spec:
  containers:
    - name: container1
      image: ...
      volumeMounts:
        - name: empty-dir
          mountPath: /mnt-1
    - name: container2
      image: ...
      volumeMounts:
        - name: empty-dir
          mountPath: /mnt-2
  volumes:
    - name: empty-dir
      emptyDir: {}
```

## hostPath

- 노드 단위 마운트되는 볼륨
- 파드들이 죽어도 hostPath의 볼륨의 데이터는 사라지지 않는다.
- 하지만 파드 입장에서 재생성될때, 같은 노드에 재생성된다는 보장이 없음.
- 대처법으로 노드 추가시 마다 마운트를 걸어줘서 해결할 수 있지만, 쿠버네티스 자체에서 해주는 역할이 아니고 관리자가 직접 마운트 해줘야 하는 단점이 있음(자동화 X)

- 보통 각각의 노드에는 각 노드 자신을 위해서 사용되는 파일들이 있음. (시스템 파일 혹은 설정 파일 등) 이러한 것들을 위해 주로 사용한다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-volume-2
spec:
  containers:
    - name: ...
      image: ...
      volumeMounts:
        - name: host-path
          mountPath: /mnt-1
  volumes:
    - name: host-path
      hostPath:
        path: /node-mnt # 사전에 해당 노드에 경로가 있어야 한다.
        type: Directory
```

### PVC/PV

- 파드의 영속성 있는 볼륨을 제공.
- k8s에서 볼륨을 사용하는 구조는 PV(PersistentVolume)과 PVC(PersistentVolumeCliam) 2개로 구성 되어 있다.
- PV에는 로컬 및 외부 원격 볼륨 등 다양하게 존재한다.
- 관리자가 미리 PV라는 볼륨을 만들어 두면, 사용자는 PVC를 만들면 k8s가 PVC에 맞는 적절한 볼륨을 연결해주는 형태이다.
- k8s는 볼륨을 파드에 직접 할당하는 방식이 아니라, 중간에 PVC를 둠으로써 파드와 파드가 사용할 스토리지를 분리하였다. (파드 입장에서는 자신이 어떤 스토리지(로컬, 원격 등)을 사용하고 있는지 알지 못해도 된다.)

출처: https://arisu1000.tistory.com/27849 [아리수]
