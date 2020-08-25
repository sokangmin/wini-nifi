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
<image src='./image/new-flow.png' width='50%' height='50%'/><br/>
UI에는 데이터흐름을 만들고 관리하는 여러 도구가 있다:<br/>
<image src='./image/nifi-toolbar-components.png' width='50%' height='50%'/><br/>

- Components Toolbar : NiFi에서 사용하는 컴포넌트들이 있다. 이 컴포넌트를 클릭하여 드래그&드롭으로 캔버스에 컴포넌트를 등록시킬 수 있다.
- Status Bar : NiFi의 현재 상황을 볼 수 있다. 실행되고 있는 태스크, Processor수 정보와 오류정보, 클러스터 노드 정보 등을 제공한다.
- Search : NiFi에 등록된 Processor, Connection을 검색할 수 있다.
- Operate Palette : NiFi컴포넌트들의 설정, 활성화/비활성화, 시작/정지, 템플릿 생성/등록, 컴포넌트 복사/붙여넣기, Processor Group 화, 컴포넌트 색 변경, 컴포넌트 삭제 등을 제공한다. 캔버스에서 컴포넌트를 선택하면, 상황에 따라 버튼들이 활성화된다. 또, 캔버스에서 Shift + 선택 또는 Shift + 선택영역 드래그를 통해 여러 개의 컴포넌트 선택 할 수 있다. (참고로, Ctrl + r은 새로고침이다.)

글로벌 메뉴에는 다음과 같은 옵션이 있다:<br/>
<image src='./image/global-menu.png' width='20%' height='20%' /><br/>

- Summary : NiFi에 등록된 컴포넌트들을 종합적으로 보고, 검색할 수 있다.
- Counter : 특정 Processor에서 발생시키는 카운트 정보를 제공한다.
- Bulletin Board : 시스템의 문제 등을 볼 수 있다.
- Data Provenance : 데이터를 추적할 수 있다.
- Controller Settings : FlowFile Controller의 설정(쓰레드 개수)과 DB Poll, Cache 서비스와 같은 컨트롤러 서비스를 관리한다.
- Flow Configuration History : FlowFile의 등록, 삭제, 변경 등의 이력을 제공한다.
- Users, Polices : 사용자 및 권한을 관리 한다. 인증시스템(Https, Kerberos, Ldap 등)이 활성화된 경우에만 메뉴가 보인다.
- Templates : Processor와 그 들의 연결정보인 Connection 컴포넌트를 속성까지도 유지 한 체 템플릿화 할 수 있는데, 이렇게 등록된 템플릿을 조회하고, 내려받을 수 있는 기능을 제공한다.
- Help : 도움말을 제공한다.
- About : NiFi버전 정보를 제공한다

### Adding a Processor
캔버스에 Processor를 추가하여 데이터흐름 생성을 시작한다. 화면왼쪽상단의 Processor 아이콘(<image src='./image/iconProcessor.png' width='2%' height='2%'/>)을 캔버스로 드래그하면 추가 할 Processor를 선택할 수 있는 대화 상자가 표시된다: <br/>
<image src='./image/add-processor.png' width='50%' height='50%'/><br/>
여기서는 예시로 로컬디스크에서 NiFi로 파일을 가져오려고한다고 가정한다. 대화상자의 오른쪽 상단 모서리의 필터상자에 "local"로 검색한다. 그러면 "l

## 출처
- https://nifi.apache.org/docs/nifi-docs/html/overview.html
