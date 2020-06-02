# 기본사용법
이 글은 Apache NiFi의 기본 사용법에 대해 설명한다. <br/>
Apache NiFi의 기본 개념 및 컨셉을 이해하고 있다는 가정에서 진행한다.


## NiFi 웹 구성 요소<br/>
NiFi 웹 서비스에 접속하면, 아래 그림과 같은 화면을 볼 수 있다.<br/>
<img src="./image/image10.png"></img>
### Components Toolbar
NiFi에서 사용하는 컴포넌트들이 있다. 이 컴포넌트를 클릭하여 드래그&드롭으로 캔버스에 컴포넌트를 등록시킬 수 있다.
### Global Menu
아래 그림과 같은 메뉴로 구성되어있다.<br/>
<img src="./image/image11.png"></img>
- Summary : NiFi에 등록된 컴포넌트들을 종합적으로 보고, 검색할 수 있다.
- Counter : 특정 Processor에서 발생시키는 카운트 정보를 제공한다.
- Bulletin Board : 시스템의 문제 등을 볼 수 있다.
- Data Provenance : 데이터를 추적할 수 있다.
- Controller Settings : FlowFile Controller의 설정(쓰레드 개수)과 DB Poll, Cache 서비스와 같은 컨트롤러 서비스를 관리한다.
- Flow Configuration History : FlowFile의 등록, 삭제, 변경 등의 이력을 제공한다.
- Users, Polices : 사용자 및 권한을 관리 한다. 인증시스템(Https, Kerberos 등)이 활성화된 경우에만 메뉴가 보인다.
- Templates : Processor와 그 들의 연결정보인 Connection 컴포넌트를 속성까지도 유지 한 체 템플릿화 할 수 있는데, 이렇게 등록된 템플릿을 조회하고, 내려받을 수 있는 기능을 제공한다.
- Help : 도움말을 제공한다.
- About : NiFi버전 정보를 제공한다.

### Status Bar
NiFi의 현재 상황을 볼 수 있다. 실행되고 있는 태스크, 프로세스 개수 정보와 오류 정보, 클러스터 노드 정보 등을 제공한다.
### Search
NiFi에 등록된 Processor, Connection을 검색할 수 있다.
### Operate Palette
NiFi 컴포넌트들의 설정, 활성화/비활성화, 시작/멈춤, 템플릿 생성/등록, 컴포넌트 복사/붙여넣기, Processor Group 화, 컴포넌트 색 변경, 컴포넌트 삭제기능을 제공한다.<br/>
캔버스에서 컴포넌트를 선택하면, 상황에 따라 버튼들이 활성화된다. 또, 캔버스에서 Shift + 선택 또는 Shift + 선택영역 드래그를 통해 여러 개의 컴포넌트를 선택 할 수 있다.

## NiFi Processor 등록 및 연결
NiFi는 Prcessor 등록 및 연결을 통해 모든 연계 흐름을 작성한다. 간단한 연계 흐름 작성을 예제로 Processor 등록 및 연결을 설명한다. 
### Processor 등록
NiFi는 Processor 등록부터 시작한다. 데이터의 시작과 종료를 모두 Processor로 수행하므로 가장 많이 사용하는 기본 기능이다.
- Processor 등록을 위해서는 Component Toolbar의 Processor 아이콘(<img src="./image/image12.png"></img>)을 선택하여, 캔버스의 원하는 위치에 드랍한다.<br/>
<img src="./image/image13.png"></img>
- 사용할 Processor를 테이블에서 선택하고, ADD버튼을 눌러 등록한다.(예제에서는 GenerateFlowFile Processor을 선택)<br/>
<img src="./image/image14.png"></img>
- 동일한 방식으로 Log를 출력할 때 쓰는 Log Attribute Processor를 등록한다.<br/>
<img src="./image/image15.png"></img>
- 아래와 같이 Processor를 구성한다.<br/>
<img src="./image/image17.png"></img>

### Relationship 연결
Relationship을 사용하여 각 프로세스에서 발생하는 데이터를 어디로 보낼지 설정 할 수 있다. 예제에서는 GenerateFlowFile -> LogAttribute로 보낸다.
- GenerateFlowFile에 마우스를 오버하면 Relationship을 설정하는 화살표가 나타난다.
- 이 화살표를 드래그하여 아래의 LogAttribute에 연결한다.<br/>
<img src="./image/image18.png"></img>
- 아래와 같이 Relationship을 구성한다.<br/>
<img src="./image/image19.png"></img>

### Processor 설정
Configure를 통해 각 프로세서의 세부설정을 수정한다.<br/>
GenerateFlowFile, LogAttribute의 몇몇 정보를 설정하고 저장한다.

- GenerateFlowFile Processor에서 오른쪽 마우스를 클릭하고 Configure를 선택한다.<br/>
<img src="./image/image20.png"></img>
- SCHEDULING 탭의 Run Schedule를 0 sec에서 5sec로 수정한다.<br/>
<img src="./image/image21.png"></img>
- PROPERTIES 탭의 Custom Text에 Hello World!를 입력하고 OK버튼을 클릭한다.<br/>
<img src="./image/image22.png"></img>
- 동일한 방식으로 LogAttribute의 세부 설정을 수정한다.<br/>
  - SETTINGS 탭의 Automatically Terminate Relationships의 success항목을 체크한다.
  - PROPERTIES 탭의 Log Payload를 true로 수정한다.

※ 아래와 같이 Processor에 느낌표가 표시되면 세부설정이 invalid해서 아직 구동할 준비가 되지 않았다는 표시입니다.<br/>
위의 설정을 다시 체크해보시기 바랍니다.<br/>
<img src="./image/image16.png"></img>

### Processor 실행 및 정지
- 구동할 Processor를 선택하고  [Operate Palette](#operate-palette)의 시작 버튼을 클릭한다.<br/>
<img src="./image/image23.png"></img>
- 정지할 Processor를 선택하고 [Operate Palette](#operate-palette)의 정지 버튼을 클릭한다.<br/>
<img src="./image/image24.png"></img>

### 연계이력확인
- [Global Menu - Data Provenance](#global-menu)메뉴를 선택한다.<br/>
- 조회버튼을 클릭하고 선택한 항목의 View Details를 클릭한다.<br/>
<img src="./image/image25.png"></img>
- Content 탭의 VIEW를 클릭하고 본문내용이 Hello World!인지 확인한다.<br/>
<img src="./image/image26.png"></img><br/>
<img src="./image/image27.png"></img>


<!--Processor를 생성만 하면 아직 구동할 준비가 되지 않아 아래와 같이 느낌표 아이콘이 뜬다. 세부설정을 세팅하여 구동준비상태로 수정한다.<br/>
느낌표아이콘에 마우스를 가져가면 세팅해야할 설정내용을 표시한다.<br/>
<img src="./image/image16.png"></img>
- GenerateFlowFile Processor에서 오른쪽 마우스를 클릭하고 Configure를 선택한다.<br/>

<img src="./image/image16.png"></img>-->