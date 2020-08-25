# Getting Started with Apache NiFi
## Terminology Used in This Guide
NiFi를 사용하는데 필요한 핵심용어를 개략적으로 설명한다.
- FlowFile : 사용자가 처리를 위해 NiFi로 가져오는 데이터를 FlowFile이라고 한다. FlowFile은 Attribute(속성), Content(본문)으로 구성된다. Content는 사용자 데이터 자체이다. Attribute는 사용자 데이터와 연관된 key-value 속성값이다.
- Processor : Processor는 FlowFile의 생성, 전송, 수신, 변환, 라우팅 ,분할, 병합 및 처리를 담당하는 NiFi 구성요소이다.
## NiFi 설치 및 구동
- [NiFi 기본설치방법](./docs/tutorial_install.md)
- [NiFi Cluster 설치방법](./docs/tutorial_cluster_install.md)
- [NiFi Registry 설치 및 적용방법](./docs/tutorial_registry.md)
- [NiFi 와 LDAP 연동방법](./docs/tutorial_nifi_ldap.md)
- [NiFi Site-to-Site 구성방법](./docs/tutorial_S2S_install.md)

## Started NiFi. Now What?
NiFi가 시작되었으므로 데이터 흐름을 만들고 모니터링하기 위해 사용자 인터페이스를 불러올 수 있다. 시작하려면 웹 브라우저를 열고 http://localhost:8080/nifi 로 이동한다. 포트는 설정파일로 변경 기본포트는 8080이다. ([NiFi 포트 변경 및 https접속방법](./docs/tutorial_conf.md))<br/>
그러면 데이터 흐름을 조정하기 위한 빈 캔버스인 사용자 인터페이스가 나타난다:<br/>
<image src='./image/new-flow.png' width='70%' height='70%'/><br/>
UI에는 데이터흐름을 만들고 관리하는 여러 도구가 있다:<br/>
<image src='./image/nifi-toolbar-components.png' width='70%' height='70%'/><br/>
글로벌 메뉴에는 다음과 같은 옵션이 있다:<br/>
<image src='./image/global-menu.png' /><br/>


## High Level Overview of Key NiFi Features
주요특징에 대한 개략적인 설명이다. 주요 특징 범주에는 흐름관리, 사용 용이성, 보안, 확장 가능한 아키텍쳐, 유연한 확장 모델이 포함된다.

- Flow Management(흐름관리)
  - Guaranteed Delivery<br/>
    NiFi의 핵심철학은 높은 수준의 Guaranteed Delevery 이다. 이는 persistent write-ahead log 및 content repository를 사용함으로써 달성된다. 모든 flowfile에 대한 정보를 저장하여 데이터 유실을 방지한다.
  - Data Buffering w/ Back Pressure and Pressure Release<br/>
    NiFi는 Queue에 대기하고 있는 모든 데이터의 버퍼링은 물론 지정한 제한에 도달할 때의 Back Pressure 및 지정된 시간(만료시간)에 도달하면 데이터를 에이징(소멸)하는 기능을 제공한다.
  - Prioritized Queuing<br/>
    Queue에 대기하고 있는 데이터에 대한 우선순위를 제공한다. FirstInFirstOut, NewestFlowFireFirst, OldestFlowFileFirst, PriorityAttribute 등을 지원한다.
  - Flow Specific QoS (latency v throughput, loss tolerance, etc.)<br/>
    데이터의 특성에 따라 중요도(가치)가 다르다.(처리시간, 주기 등) NiFi는 이러한 데이터 특성에 따른 flow별 구성이 가능하다.
- Ease Of Use(사용 용이성)
  - Visual Command and Control<br/>
    데이터 흐름은 매우 복잡해질 수 있다. 이러한 흐름을 시각화하면 복잡성을 줄이고 단순화해야하는 영역을 식별하는 데 도움이 될 수 있다. NiFi는 데이터 흐름의 시각화뿐만 아니라 실시간으로 데이터흐름을 변경하면 변경 사항이 즉시 적용된다. 변경사항은 일반적으로 Processor단위와 같은 구성요소로 세분화되고 격리된다. 특정 수정을 하기 위해 전체 흐름을 중지 할 필요가 없다.
  - Flow Templates<br/>
    데이터의 흐름은 패턴화 될 수 있으며 이러한 모범 사례를 공유 할 수 있으면 많은 도움이 된다. Flow Template를 사용하면 데이터 흐름 디자인을 재사용 및 다른 개발자와 공유할 수 있다.
  - Data Provenance<br/>
    NiFi는 데이터가 시스템을 통해 변경되는 이력(출처)데이터를 저장, 색인화, 검색을 지원한다. 이 정보는 디버깅, 최적화, 그 밖의 상황을 판단하는데 중요한 정보가 된다.
  - Recovery / Recording a rolling buffer of fine-grained history<br/>
    Content repository는 데이터의 롤링 버퍼 역할을 하도록 설계되었다. 데이터는 content repository에서 만료되거나 저장공간이 부족할 때만 제거된다. 이는 Data Provenance와 결합되어 content 보기, 다운로드, replay을 가능하게 한다.
- Security(보안)
  - System to System<br/>
    NiFi는 양방향 SSL과 같은 암호화 프로토콜을 통한 안전한 교환을 제공한다. 또한 발신자/수신자에서 공유 키 또는 기타 메커니즘을 사용하여 content를 암호화 및 복호화하는 기능을 제공한다.
  - User to System<br/>
    NiFi는 양방향 SSL인증을 활성화하고 플러그 형 인증(keberos, ldap등)을 제공하여 사용자의 액세스와 권한을 적절하게 제어 할 수 있도록 한다. 사용자가 암호화 같은 민감한 속성을 사용하여 flow를 작성하면 서버는 민감한 정보를 암호화하고 암호화된 형태로도 클라이언트 측에 노출하지 않는다.
  - Multi-tenant Authorization<br/>
    NiFi는 권한수준을 각 구성요소에 적용되어 관리자가 액세스를 제어할 수 있도록 한다. 각 개인, 팀, 조직별로 접근 가능한 데이터 흐름을 격리하여 Multi-tenant가 가능하도록 제공한다.
- Extensible Architecture(확장 가능한 아키텍쳐)
  - Extension<br/>
    NiFi는 확장가능하게 설계되어 있다. 확장 범위는 Processor, controller service, report task, prioritizer, 사용자UI 등이 있다.
  - Classloader Isolation<br/>
    NiFi는 사용자정의 클래스 로더 모델을 제공하여 각 확장 번들이 매우 제한된 종속성 세트에 노출되도록 한다. 결과적으로 확장 번들은 다른 번들과 추돌 할 수 있는지 여부에 관심없이 빌드 할 수 있고 종속성 문제는 방지한다. 
  - Site-to-Site Communication Protocol<br/>
    NiFi 인스턴스간에 선호되는 통신 프로토콜은 NiFi Site-to-Site(S2S) 프로토콜이다. S2S를 사용하면 한 NiFi인스턴스에서 다른 NiFi인스턴스로 쉽고 효율적이며 안전하게 데이터를 전송할 수 있다. NiFi 클라이언트 라이브러리는 S2S를 통해 NiFi와 통신하기 위해 다른 App 또는 장치에 쉽게 빌드되고 번들로 제공 될 수 있다. 소켓 기반 프로토콜과 HTTP(S)프로토콜은 모두 기본 전송 프로토콜로 S2S에서 지원되고 S2S통신에 프록시 서버를 내장할 수 있다.
- Flexible Scaling Model(유연한 확장 모델)
  - Scale-out (Clustering)<br/>
    NiFi는 여러 노드를 함께 클러스터링하는 사용을 통해 확장하도록 설계되어있다. 싱글노드가 프로비저닝되고 초당 수백 MB를 처리하도록 구성되어 있으면 보통의 클러스터가 초당GB를 처리하도록 구성 될수 있다. 
  - Scale-up & down
    NiFi는 유연한 방식으로 Scale-up 및 축소하도록 설계되어있다. 스케줄링 탭에서 프로세서의 동시작업수를 조정하여 처리량을 조절할 수 있다. 이를 통해 더 많은 프로세스가 동시에 실행되어  더 많은 처리량을 제공된다. 다른 측면에서는 제한된 하드웨어 리소스로 인해 [MiNiFi](https://nifi.apache.org/minifi/index.html)를 이용하여 NiFi를 축소하여 사용할 수도 있다.
    
## 출처
- https://nifi.apache.org/docs/nifi-docs/html/overview.html
