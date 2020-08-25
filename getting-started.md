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

### Adding a Processor
캔버스에 Processor를 추가하여 데이터흐름 생성을 시작한다. 화면왼쪽상단의 Processor 아이콘(<image src='./image/iconProcessor.png' width='3%' height='3%'/>)을 캔버스로 드래그한다:
    
## 출처
- https://nifi.apache.org/docs/nifi-docs/html/overview.html
