# NiFi 기본설치방법(Standalone모드)
이 글은 Apache NiFi의 기본설치방법에 대해 설명한다. <br/>
- OS : CentOS 7.3 64bit
- Apache Nifi : 1.13.2

※ ~~테스트용(http,익명사용자 모드)~~ 으로 사용시에는 4~6작업은 생략해도 됨.

### 1. nifi계정을 생성한다.
- root 계정으로 접속 <br/>
- nifi 계정 생성
```bash
$ groupadd nifi 
$ useradd -g nifi nifi
$ passwd nifi
```
- nifi 계정으로 재접속
### 2. JDK를 다운로드하고 환경변수를 등록한다.
- jdk 다운로드 url : https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
```bash
$ tar -xzvf jdk-11.0.11_linux-x64_bin.tar.gz
$ vi .bash_profile
export JAVA_HOME=/home/nifi/jdk-11.0.11
PATH=$JAVA_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin

$ . .bash_profile
$ java -version
```
### 3. Apache NiFi 사이트(https://nifi.apache.org/download.html) 에 접속하여 nifi 및 toolkit Binary파일을 다운로드하고 압축을 해제한다.
```bash
$ wget https://mirror.navercorp.com/apache/nifi/1.13.2/nifi-1.13.2-bin.tar.gz
$ wget https://mirror.navercorp.com/apache/nifi/1.13.2/nifi-toolkit-1.13.2-bin.tar.gz
$ tar -xzvf nifi-1.13.2-bin.tar.gz
$ tar -xzvf nifi-toolkit-1.13.2-bin.tar.gz
```
### 4. toolkit을 사용하여 인증서를 생성한다.
```bash
$ {toolkit 설치 디렉토리}/bin/tls-toolkit.sh -n '호스트명' -C '클라이언트 정보' -o 'output 경로'
-n : 서버인증서 호스트명
-C : 관리자/사용자로 사용할 클라이언트 인증서 정보
-o : output 경로
ex> ./bin/tls-toolket.sh standalone -n 'winiot.w[01-07](2)' -C 'CN=admin, OU=winiot' -o './target' 
```
### 5. 생성된 인증서 파일을 NiFi로 복사한다.
```bash
$ cp {toolkit 설치 디렉토리}/target/{host명}/* {NiFi 설치 디렉토리}/conf/
```
### 6. {NiFi 설치 디렉토리}/conf/authorizers.xml을 아래와 같이 수정한다.
- userGroupProvider 수정
```xml
    <userGroupProvider>
        <identifier>file-user-group-provider</identifier>
        <class>org.apache.nifi.authorization.FileUserGroupProvider</class>
        <property name="Users File">./conf/users.xml</property>
        <property name="Legacy Authorized Users File"></property>
        <property name="Initial User Identity 1">CN=admin, OU=winiot</property> // 관리자용 클라이언트 인증서 정보
        <property name="Initial User Identity 2">CN={호스트명}, OU=NIFI</property> // 서버 인증서 정보
    </userGroupProvider>
```
- accessPolicyProvider 수정
```xml
    <accessPolicyProvider>
        <identifier>file-access-policy-provider</identifier>
        <class>org.apache.nifi.authorization.FileAccessPolicyProvider</class>
        <property name="User Group Provider">file-user-group-provider</property>
        <property name="Authorizations File">./conf/authorizations.xml</property>
        <property name="Initial Admin Identity">CN=admin, OU=winiot</property> // 관리자용 클라이언트  정보
        <property name="Legacy Authorized Users File"></property>
        <property name="Node Identity 1">CN={호스트명}, OU=NIFI</property> // 서버 인증서 정보
        <property name="Node Group"></property>
    </accessPolicyProvider>
```

### 7. NiFi를 구동한다.
- 실행
```bash
- foreground
$ {NiFi 설치 디렉토리}/bin/nifi.sh run
- background
$ {NiFi 설치 디렉토리}/bin/nifi.sh start
```
- 정지
```bash
- foreground
Ctrl-c를 입력
- background
$ {NiFi 설치 디렉토리}/bin/nifi.sh stop
```

### 8. 기타
- invalid host header 장애<br/>
<image src='../image/image_tutorial_install_001.png?raw=true' width='70%' height='70%'/><br/>
    - 원인: NiFi가 https로 실행되는 경우 바인딩 된 host[:port]와 일치하는 Host헤더가 있는 HTTP요청만 허용한다.<br/>
    다른 host[:port]로 향하는 요청(프록시, 컨테이너환경 등)을 수락하려면 해당 설정을 수정해야 한다.<br/>
    - 해결방안: 
    nifi.properties 수정
    ```properties
    nifi.web.proxy.host = host:port
    ```

### ※ 참고
- https://nifi.apache.org/docs/nifi-docs/html/toolkit-guide.html#tls_toolkit
- https://bryanbende.com/development/2016/08/30/apache-nifi-1.0.0-secure-site-to-site
- https://bryanbende.com/development/2016/08/17/apache-nifi-1-0-0-authorization-and-multi-tenancy
- 일반유저 sudo권한추가 (https://info-lab.tistory.com/163)
