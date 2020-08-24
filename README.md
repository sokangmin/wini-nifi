# Apache NiFi Overview
## What is Apache NiFi?
Apache NiFi는 아파치 소프트웨어 재단의 오픈소스( https://nifi.apache.org/ ) 로써, 엔터프라이즈 환경(점점 복잡해지는 시스템, 데이터유실, 시스템 장애대처, 실시간 처리 이슈 등)에서 이기종 데이터 소스 및 시스템간의 정보 흐름을 효율적으로 처리, 관리, 모니터링 하기 위해 만들어졌다.

## The core concepts of NiFi
NiFi의 기본 설계 개념은 [Flow Based Programming](https://en.wikipedia.org/wiki/Flow-based_programming#Concepts) 의 주요 아이디어와 밀접한 관련이 있다. 다음은 주요 NiFi 개념과 FBP와 어떻게 연결되는지 보여준다.
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
- FlowFile Repository : 현재 구동중인 FlowFile에 대한 상태를 저장하는 공간이다. 기본적으로 디스크에 [Write-Ahead Log](https://en.wikipedia.org/wiki/Write-ahead_logging) 방식으로 쓰여진다.
- Content Repository : FlowFile의 Body(contents)를 저장하는 공간이다. 기본적으로 디스크에 저장되며 둘 이상의 디스크에 저장되도록 변경 가능하다.
- Provenance Repository : 모든 데이터들의 이력이 저장되는 공간이다. 기본적으로 디스크에 저장되며 모든 데이터들은 색인화되고 검색 가능하다.(Apache Lucene 사용)

NiFi는 클러스터 내에서도 작동 할 수 있다.<br/>
<image src='./image/zero-leader-cluster.png' width='50%' height='50%'/>
