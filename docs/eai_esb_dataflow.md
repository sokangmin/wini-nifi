# EAI, ESB, DataFlow Engine 비교

## 시스템 통합 문제
메인프레임 시대에서 유닉스 시스템으로 내려오면서 부터 시스템들은 업무 단위로 분리가 되기 시작했다.<br/> 
ERP, CRM 등과 같은 시스템으로, 은행은 대내, 대외, 정보계와 같이 시스템으로 잘게 나눠지기 시작했는데, 당연히 이렇게 나눠진 시스템 사이에는 통신이 필요하게 되었고,<br/>
시스템이 거대화 되가면서, 시스템간에 직접 P2P로 통신하는 구조는 한계에 다르기 시작하였다.<br/>
<img src="./image/image4.png"></img><br/>
시스템이 서로 얽히고 어느 시스템이 어떤 시스템과 통신하는지 통제가 어렵게 되는 상황이 되었다.

## EAI(Enterprise Application Integration)
이러한 시스템간의 문제를 해결하기 위해서 등장한 솔루션이 EAI인데, 통합을 원하는<br/>
시스템을 기존에는 직접 1:1로 붙였다면, EAI는 중앙에 허브역할을 하면서, 모든 통신을 EAI를 거치도록 하였다.<br/>
<img src="./image/image2.png"></img><br/>
EAI의 가장 큰 특징은 표준화 되지 않은 이기종 시스템간의 연동을 가능하게 해준다는 것이다.<br/> 
메인프레임→Unix ERP시스템으로 테이터를 전송하게 한다던지 Oracle→CRM시스템으로 데이터를 전송해주는 것과 같은 시스템 통합을 지원했는데,<br/> 
이는 이 기종간에 통신 프로토콜이나 통합 방식을 변경할 수 있는 아답터를 제공하기 때문이다.<br/>
EAI는 복잡한 메시지 처리나 변동, 라우팅같은 다양한 기능을 가지고 있었지만, 주로 이 기종간의 메시지 변환이 가장 많이 사용되었다.<br/>
어쨌거나 이런 EAI는 중앙 통제를 통해서 1:1/다:다로 통신되는 복잡한 토폴로지를 통합하는 의미가 있다.<br/>
EAI시스템이 점점 더 많아지자, 시스템 통합 아키텍쳐도 패턴화(EIP, Enterprise Integration Pattern, https://www.enterpriseintegrationpatterns.com/patterns/messaging/toc.html) 되었다.<br/>

## SOA/ESB(Enterprise Service Bus)
이 기종간의 통합이 많아지고, 시스템이 점점 분리되다 보니, 아예 이를 표준화하고자 하는 작업이 진행되었는데, 이것이 바로 SOA(Service Oriented Archtiecture / 서비스 지향 아키텍처)이다.<br/>
SOA는 시스템을 서비스로 나눈 다음 표준화된 인터페이스로 통신하다는 컨셉이고 ESB는 SOA의 구현체 중 하나이다. <br/>
ESB는 시대적으로 벤더들에 의해 그 당시 유행하던 웹서비스(XML/HTTP(SOAP ))와 EIP로 포장되었다. <br/> 
웹서비스 기반으로 통신이 표준화되었기 때문에 서비스간의 통신은 EAI처럼 별도의 아답터가 필요없어졌다.<br/> 
대신 서비스간의 통신을 서비스 버스라는 통신 백본을 이용하여 통신을 하는 구조가 되었다.<br/>
<img src="./image/image1.png"></img><br/>

## Dataflow Engine
빅데이터와 IOT가 급증하면서 대용량 파일시스템, NoSQL, MQ 등 데이터 저장소와의 연계에 대한 이슈가 많아졌다. <br/>
복잡해지는 기업의 시스템들에서 데이터의 전송 경로가 더 복잡해지고, 실시간 처리가 중요해지고 있습니다. <br/>
그래서 시스템 간 데이터 전달을 효율적으로 처리, 관리, 모니터링하기 위한 DataFlow Engine가 나타나게 되었다. <br/>
EAI, ESB는 시스템 및 서비스 통합에 초점을 두고 있는 반면 DataFlow Engine는 저장소에 저장된 데이터에 초점을 두고 있습니다. <br/>
Flow Based Programming(fbp, http://en.wikipedia.org/wiki/Flow-based_programming#Concepts) 을 기본 컨셉으로 Application을 네트워크의 개념을 토대로 정의하며<br/>
파이프라인(Processor-<connection>-Processor)의 형태로 메시지를 전달하면서 데이터를 처리하는 개념이고 DataFlow Engine는 구현체입니다.<br/>
대표적인 Dataflow Engine로는 Apache NiFi(https://nifi.apache.org/), StreamSet(https://streamsets.com/) 이 있습니다.<br/>
<img src="./image/image3.png"></img><p/>

※ 참고 - [EAI,ESB,API 게이트웨이,서비스 매쉬 - 서비스 통합의 역사](https://bcho.tistory.com/search/esb)
