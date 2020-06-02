# Site-to-Site
NiFi의 한 인스턴스에서 다른 NiFi 인스턴스로 데이터를 전송할 때 사용하는 프로토콜입니다.<br/>
Site-to-Site을 사용하면 NiFi 인스턴스간의 데이터를 안전하고 효율적으로 전송할 수 있다.

## 장점
- 손쉬운 설정
  - 원격 NiFi 인스턴스의 URL을 입력하면 사용 가능한 포트가 자동으로 검색되고 목록으로 제공된다.
- 데이터 보안
  - 데이터를 암호화하고 인증 및 권한을 부여하기 위해 인증서를 사용한다.
- 효율적인 데이터 전송
  - 데이터 전송간의 오버헤드를 피하기 위해 FlowFiles의 배치 전송을 허용한다.
- 신뢰적인 데이터 전송
  - 체크섬을 이용해 데이터가 손상이 없는지 확인한다. 체크섬이 일치하지 않으면 트랙잰션이 취소되고 재시도한다.
- FlowFile의 속성 유지
  - FlowFile이 이 프로토콜을 통해 전송되면 원격 인스턴스로 모든 FlowFile의 속성이 자동으로 전송됩니다.
  - 모든 속성이 같이 전송되기 때문에 원격 인스턴스에서 데이터를 쉽게 라우팅하고 검사할 수 있게하여 유용하게 쓰일수 있다. 

## 데이터 흐름 방향
- Push : Client가 Remote Process Group에 데이터를 보내고, Server가 Input Port로 데이터를 수신
- Pull : Client가 Remote Process Group에서 데이터를 수신하면, Server가 Output Port로 데이터를 전송<br/>

A — push → B ← pull — C.<br/>
A-B, B-C 둘 다 최종적으로는 B로 데이터가 모인다. 다만, A-B는 B가 서버로 동작하고 B-C는 C가 서버로 동작한다.<br/>
인프라 상황(방화벽정책 등)에 따라 적절한 방향을 선택해 사용하면 된다.

## Site-to-Site Server NiFi 인스턴스 설정
- Push 경우
  1. Component Toolbar의 Input Port 아이콘(<img src="./image/image29.png"></img>)을 선택하여, Root Process Group 캔버스의 원하는 위치에 드랍한다.
  2. Input Port Name을 입력하고 ADD버튼을 클릭한다.
- Pull 경우
  1. Component Toolbar의 Output Port 아이콘(<img src="./image/image30.png"></img>)을 선택하여, Root Process Group 캔버스의 원하는 위치에 드랍한다.
  2. Output Port Name을 입력하고 ADD버튼을 클릭한다.

## Site-to-Site Client NiFi 인스턴스 설정
1. Component Toolbar의 Remote Process Group 아이콘(<img src="./image/image31.png"></img>)을 선택하여, 캔버스의 원하는 위치에 드랍한다.
2. URLs와 Transprot Protocol을 입력한다.
   - URLs은 Server NiFi 인스턴스의 url을 입력한다.(ex>http://remotehost/nifi, https://remotehost:8443/nifi)
   - Transport Protocol을 선택한다.<br/>

<img src="./image/image32.png"></img><br/>
3. Remote Process Group에서 오른쪽 마우스를 클릭하고 Manage remote ports를 선택한다. 원격인스턴스의 Port정보가 맞는지 확인한다.

<img src="./image/image33.png"></img><br/>
4. Relationship 연결을 통해 Processor와 Remote Process Group을 연결하고 연결할 포트를 선택한다.

<img src="./image/image34.png"></img><br/>

## 주의사항
- Transport Protocol 설정<br/>
NiFi에서는 기본으로 Http를 사용한다. RAW로 사용할려면 conf/nifi.properties파일을 아래와 같이 수정하면 된다.
```properties
# agent와 collector간 데이터 연계시, tcp소켓통신으로 사용할 포트
# agent와 collector간 데이터 연계 방법은 http(s), socket등 2가지 방법이 있음.
# http방식은 기본으로 enable로 설정되어 있고 만약 http를 사용못할 경우 tcp소켓통신사용 할 수 있음.
nifi.remote.input.socket.port=<RAW port정보>
nifi.remote.input.http.enabled=false
```
- Remote host 설정<br/>
Site-to-SIte Client NiFi 인스턴스 설정을 하면 Server 인스턴스의 host정보를 받아온다. 기본으로 hostname으로 받아오기 때문에<br/>
ip, domain으로 받기를 원한다면 conf/nifi.properties파일을 아래와 같이 수정하면 된다.
```properties
# Site to Site properties
nifi.remote.input.host=<ip or domain 정보>
```