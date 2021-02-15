# Deployment Strategy

다양하게 발전하고 있는 서비스 배포 전략 기법에 대해서 정리해봤습니다.

## 1. Recreate

- 가장 단순한 배포 전략으로, 기존 버전의 파드를 모두 삭제한 다음 새로운 버전의 파드를 생성하는 방법.

단점)

- 서비스에 대한 일시적인 DownTime이 존재한다. (무중단 배포 X)

<img src ="https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt2bcee413a9844e96/5ccb571c43283e8d640ed147/recreate-deployment-ww.png">

## 2. Rolling Update

- 기존 버전의 서버를 하나씩 죽이고 새로운 버전의 서버를 하나씩 띄우면서 순차적으로 교체하는 방법이다.
- 즉, 서버를 하나 하나씩 버전을 업그레이드 하는 방식

장점)

- 배포 중 추가 자원을 요구하지만, 서비스 DownTime 시간이 없음

단점)

- 하지만, 이전의 버전과 새로운 버전이 공존하는 시간이 발생하는 단점이 있음.

<img src ="https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt6743d826f9bc314f/5ccb56f2887e04ba691710fa/rolling-deployment-ww.png">

## 3. Blue/Green

<img src ="https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt3bd39fbb7a30f3f6/5ccb574ce8ec6ef265db8001/blue-green-deployment-ww.png">

- 구 버전과 새로운 버전의 2가지를 서버에 마련하고, 이를 한꺼번에 교체하는 방법.
- ~~이전 버전을 블루, 신버전을 그린이라고 하네요~~

장점)

- 서비스 DownTime이 존재하지 않고, 롤백이 쉬움.
- 이전 버전과 새로운 버전의 공존하는 시간이 존재하는 Rolling Update의 문제를 해결할 수 있음.
- 운영 환경에 영향을 주지 않고 실제 서비스 환경으로 새 버전 테스트가 가능하다.

단점)

- 배포 시 시스템 자원의 2배를 사용하는 단점

## 4. Canary

<img src="https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt1942369a1c20bf82/5ccb56d2683c75ef6553878b/canary-deployment-ww.png">

> 먼저 용어의 어원을 보면 카나리아는 메탄, 일산화탄소에 매우 민감한 새라, 가스에 노출되면 죽어버리게 된다. 그래서 옛날에 카나리아가 노래를 계속하고 있는 동안 광부들은 안전함을 느낀 채 일 할 수 있었으며, 카나리아가 죽게 되면 곧바로 탄광을 탈출함으로써 자신의 생명을 보존할 수 있었다. ~~마음이 찡하네요ㅠㅠ~~

- Canary 배포는 어원처럼 위험을 빠르게 감지할 수 있는 배포 기법
- 구 버전의 서버와 새로운 버전의 서버들을 구성하고 일부 트래픽을 새 버전으로 분산시켜 테스트를 진행한다
- 이 결과에 따라 새 버전을 프로덕션 서버로 사용될 수 있고, 문제가 있으면 다시 구버전으로 돌아갈 수 있는 기법이다.
- 이 기법으로 A/B테스트도 가능하다.

출처) https://www.weave.works/blog/kubernetes-deployment-strategies
