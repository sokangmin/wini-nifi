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
NiFi의 주요특징에 대한 개략적인 설명이다. 주요 특징 범주에는 흐름관리, 사용 용이성, 보안, 확장 가능한 아키텍쳐, 유연한 확장 모델이 포함된다.

- Flow Management(흐름관리)
