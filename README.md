# Apache NiFi Overview
## What is Apache NiFi?
Apache NiFi는 아파치 소프트웨어 재단의 오픈소스( https://nifi.apache.org/ ) 로써, 엔터프라이즈 환경(점점 복잡해지는 시스템, 데이터유실, 시스템 장애대처, 실시간 처리 이슈 등)에서 이기종 데이터 소스 및 시스템간의 정보 흐름을 효율적으로 처리, 관리, 모니터링 하기 위해 만들어졌다.

## The core concepts of NiFi
NiFi의 기본 설계 개념은 [Flow Based Programming](https://en.wikipedia.org/wiki/Flow-based_programming#Concepts) 의 주요 아이디어와 밀접한 관련이 있다. 다음은 주요 NiFi 개념이 FBP와 어떻게 연결되는지 보여준다.
| NiFi 용어 | FBP 용어 | 설명 |
|:--------:|:--------|:--------|
| FlowFile | Information Packet | Nifi에서 데이터를 표현하는 객체로, Key/Value 형태의 데이터 속성(Attribute)과 데이터(Content)를 포함할 수 있다. 데이터는 0바이트 이상의 데이터가 저장될 수 있다. FlowFile를 이용하여 여러 시스템 간의 데이터 이동이 가능하다. |
| Processor | Black Box | FlowFile은 여러 단계에 걸쳐 속성이 추가되거나 내용이 변경될 수 있는데, 이때 사용되는것이 Processor이다. NiFi는 150개 이상의 Processor를 제공하며, 이를 이용하여 FlowFile을 다양한 시스템으로부터 읽어와 변경, 저장, 라우팅, 중재 등을  할 수 있다. | 
| Connection | Bounded Buffer | Processor간의 연결을 의미하며, NiFi의 Connection은 queue역할을 하며 라우팅, 우선순위, 역압등 기능을 통해 다양한 프로세스가  상호 작용할 수 있도록 도와준다. |
| Flow Controller | Scheduler | Processor가 어느 간격 또는 시점에 실행하는지 스케줄링한다. |
| Process Group | subset | 특정업무, 기능단위로 여러 Processor를 묶을 수 있으며, Input과 Output포트를 제공해 Process Group간의 데이터 이동이 가능하다. |

## NiFi Architecture
<image src='./image/zero-leader-node.png' width='50%' height='50%'/>
NiFi는 호스트 운영체제의 JVM 내에서 실행된다. JVM에서 NiFi의 주요 구성 요소는 다음과 같다:

- Web Server : NiFi는 Web UI를 통해 시스템간의 정보흐름을 개발, 제어 ,모니터링한다.
- Flow Controller : Processor가 실행될 쓰레드를 제공하고 스케줄링을 담당한다.
- Extensions : Custom Processor를 개발하여 확장할 수 있다.
- FlowFile Repository : 현재 구동중인 FlowFile에 대한 상태를 저장하는 공간이다. 기본적으로 디스크에 [Write-Ahead Log](https://en.wikipedia.org/wiki/Write-ahead_logging) 방식으로 쓰여진다.(플러그인 가능)
- Content Repository : FlowFile의 Body(contents)를 저장하는 공간이다. 기본적으로 디스크에 저장되며 둘 이상의 디스크에 저장되도록 변경 가능하다.(플러그인 가능)
- Provenance Repository : 모든 데이터들의 이력이 저장되는 공간이다. 기본적으로 디스크에 저장되며(플러그인 가능) 모든 데이터들은 색인화되고 검색 가능하다.(Apache Lucene 사용)

NiFi는 클러스터 내에서도 작동 할 수 있다.<br/>
<image src='./image/zero-leader-cluster.png' width='50%' height='50%'/><br/>
1.0 release부터 Zero-Leader Clustering기법이 사용된다. NiFi 클러스터의 각 노드는 서로 다른 데이터 집합의 데이터에 대한 동일한 작업을 수행한다. [Apache ZooKeeper](https://zookeeper.apache.org)는 클러스터 코디네이터, Primary 노드로 하나의 서버를 선택하고 장애 조치는 Zookeeper가 자동으로 처리한다. 모든 클러스터 노드는 코드네이터로 heart beat와 상태정보를 전달한다. 코드네이터는 수신받은 정보를 토대로 노드 연결 해제 및 연결을 담당한다. Primary 노드는 어떤작업에 대해서 클러스터가 아닌 단일노드로 동작해야 할때 사용한다.

## Performance Expectations and Characteristics of NiFi
NiFi는 호스트 시스템의 자원을 최대한 활용하도록 설계되어있다. 이러한 성능 최적화는 CPU 및 디스크와 밀접하게 관련되어 있다. 

- For IO<br/>
IO에 대한 예상 처리량 또는 지연시간은 데이터 저장 플러그인 방식에 따른 구성에 따라 다르다. 일반적으로 보통 디스크또는 RAID 볼륨에서 초당 약 50MB의 읽기/쓰기 속도를 가정한다. 더 나은 성능이 필요할 경우, 둘 이상의 디스크를 사용하도록 변경 하거나 다른 플러그인을 사용한다.
- For CPU<br/>
Flow Controller는 특정 Processor가 실행될 쓰레드 및 스케줄링을 담당한다. Processor는 작업 실행이 완료되는 즉시 쓰레드를 반환하도록 되어있다. Flow Controller는 쓰레드 풀을 관리하며 사용 가능한 쓰레드 수를 관리 할 수 있다. 사용하기에 이상적인 쓰레드 수는 코어 수, 다른 서비스 실행 여부 등 호스트 시스템 리소스에 따라 다르다. 일반적으로 IO를 많이 쓰는 경우, 수십 개의 쓰레드 사용이 합리적이다.
- For RAM<br/>
NiFi는 JVM내에 존재하므로 사용가능한 메모리는 JVM에서 제공하는 메모리 공간을 제한된다. JVM의 garbage collection은 총 실제 힙 크기를 제한하고 시간이 지남에 따라 애플레케이션이 얼마나 잘 실행되는지 최적화하는데  매우 중요한 요소이다.

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
    NiFi 인스턴스간에 선호되는 통신 프로토콜은 NiFi [Site-to-Site](./docs/Site2Site.md) (S2S) 프로토콜이다. S2S를 사용하면 한 NiFi인스턴스에서 다른 NiFi인스턴스로 쉽고 효율적이며 안전하게 데이터를 전송할 수 있다. NiFi 클라이언트 라이브러리는 S2S를 통해 NiFi와 통신하기 위해 다른 App 또는 장치에 쉽게 빌드되고 번들로 제공 될 수 있다. 소켓 기반 프로토콜과 HTTP(S)프로토콜은 모두 기본 전송 프로토콜로 S2S에서 지원되고 S2S통신에 프록시 서버를 내장할 수 있다.
- Flexible Scaling Model(유연한 확장 모델)
  - Scale-out (Clustering)<br/>
    NiFi는 여러 노드를 함께 클러스터링하는 사용을 통해 확장하도록 설계되어있다. 싱글노드가 프로비저닝되고 초당 수백 MB를 처리하도록 구성되어 있으면 보통의 클러스터가 초당GB를 처리하도록 구성 될수 있다. 
  - Scale-up & down
    NiFi는 유연한 방식으로 Scale-up 및 축소하도록 설계되어있다. 스케줄링 탭에서 프로세서의 동시작업수를 조정하여 처리량을 조절할 수 있다. 이를 통해 더 많은 프로세스가 동시에 실행되어  더 많은 처리량을 제공된다. 다른 측면에서는 제한된 하드웨어 리소스로 인해 [MiNiFi](https://nifi.apache.org/minifi/index.html)를 이용하여 NiFi를 축소하여 사용할 수도 있다.
    
## 출처
- https://nifi.apache.org/docs/nifi-docs/html/overview.html
