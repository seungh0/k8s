# Service

## Service의 역할

<img src="https://lh3.googleusercontent.com/proxy/IyfJW4LUFKD_jCAoWKC_M1ZEjlCwMYSIQe62N8B4YxdO5sz7mdK2bC9ZUtb4JvsLB0zXbEB5mZZ4FrpdSvG2cKwuv-VMLPI7kf6YxE1-GDoliTjv">

Service를 통해서도 파드에 접속할 수 있다.

> 여기서 의문 사항!) 왜 파드에도 IP가 할당되어 있는데 서비스 오브젝트를 통해서 접근하려고 할까?

파드는 언제든지 죽고, 재 생성될 수 있는 오브젝트이다.
따라서 파드가 재 생성되면 IP는 계속 변경된다. (파드의 IP는 언제든지 변경될 수 있어서 신뢰성이 떨어진다.)

반면에 서비스 오브젝트는 사용자가 직접 지우지 않는 한, 삭제되거나 재 생성되지 않는다. 따라서 서비스의 IP는 고정.

게다가 서비스를 사용하면 하나의 서비스에 여러 파드를 연결할 수 있음.
이러한 경우 서비스에서 트래픽을 적절히 분산시켜 파드에 연결해 준다.

## Service의 종류

먼저 서비스에 앞서서 파드를 하나 만들어 보겠다.

### 1. ClusterIP

이 IP는 쿠버네티스 클러스터 내부에서만 접근할 수 있고, 외부에서는 접근할 수 없음.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-1
spec:
  selector:
    type: web
  ports:
    - port: 9000
      targetPort: 8000
  type: ClusterIP
```

(클러스터 내에서 노드 IP의 9000번 포트로 접근 가능)

#### 사용되는 곳

따라서 주로 관리자용, 내부 대쉬보드, 쿠버네티스 서비스 상태 디버깅용 등으로 사용된다고 한다.

### 2. NodePort

서비스에 외부 트래픽을 직접 보낼 수 있는 가장 원시적인 방법으로
클러스터 외부에서도 접속할 수 있음.
모든 노드의 특정 포트를 개방해 서비스에 접근하는 방식.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-2
spec:
  selector:
    type: web
  ports:
    - port: 9000
      targetPort: 8000
      nodePort: 32000
  type: NodePort
```

(클러스터 내에서 노드의 9000번 포트로 접근 가능 하며, 추가로 아무 노드IP 로도 32000번 포트로 외부에서 접속 가능하다.
추가로 externalTrafficPolicy: Local로 설정할 경우, 해당 노드의 IP로만 접근 가능하다)

#### 사용되는 곳

주로 내부망 연결 및 임시 외부 연결용으로 사용된다고 한다.

(Nodeport에서 포트 번호를 80 또는 443으로 설정하기에는 적절하지 않으며, SSL 인증서 적용, 라우팅 등과 같은 복잡한 설정을 서비스에 적용하기 어려움 => 따라서 NodePort 서비스 그 자체를 통해 서비스를 외부로 제공하기보다는 Ingress 오브젝트에서 간접적으로 사용되는 경우가 많다.)
By. 시작하세요 도커/쿠버네티스

### 3. Load Balancer

NodePort의 특성 + @의 기능으로
LoadBalancer 타입의 서비스를 생성하면 로드밸런서가 생겨서 각각의 노드로 트래픽을 분산시켜준다.
이때 로드밸런서에 접속하기 위한 외부접속 IP는 별도의 플러그인 등을 사용해야한다.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-3
spec:
  selector:
    type: web
  ports:
    - port: 9000
      targetPort: 8000
  type: LoadBalancer
```

#### 사용되는 곳

주로 실질적인 외부 시스템 노출에 사용된다.
(내부 IP가 노출되지 않고 외부 IP를 통해 안정적으로 서비스를 노출할 수 있음)
