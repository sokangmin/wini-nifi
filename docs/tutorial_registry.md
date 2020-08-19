# NiFi Registry 설치 및 적용방법
이 글은 Apache NiFi의 Registry 설치 및 적용 방법에 대해 설명한다. </br>
- 선행작업으로 [NiFi 기본설치(Standalone모드)](./tutorial_install.md), [NiFi LDAP 설치](./tutorial_ldap.md), [NiFi와 LDAP 연동](./tutorial_nifi_ldap.md)이 미리 설치되어야 한다.

### 1. JDK를 다운로드하고 환경변수를 등록한다.
- jdk 다운로드 url : https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
```bash
$ tar -xzvf jdk-11.0.6_linux-x64_bin.tar.gz
$ vi .bash_profile
export JAVA_HOME=/home/nifi/jdk-11.0.6
PATH=$JAVA_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin
```
### 2. Apache NiFi-registry 사이트(https://nifi.apache.org/registry.html) 에 접속하여 nifi-registry Binary파일을 다운로드하고 압축을 해제한다.
```bash
$ wget http://apache.mirror.cdnetworks.com/nifi/nifi-registry/nifi-registry-0.5.0/nifi-registry-0.5.0-bin.tar.gz
$ tar -xzvf nifi-registry-0.5.0-bin.tar.gz 
```
### 3. nifi-registry.properties 수정
- 인증서정보 복사
```bash
$ cp {toolkit 설치 디렉토리}/target/{host명}/* {nifi-registry 설치 디렉토리}/conf/
```
- https 정보 수정
```bash
$ vi {nifi-registry 설치디렉토리}/conf/nifi-registry.properties
nifi.registry.web.http.host=
nifi.registry.web.http.port=
nifi.registry.web.https.host=호스트명
nifi.registry.web.https.port=18443
```
- 인증서 정보 수정
```bash
$ vi {nifi-registry 설치디렉토리}/conf/nifi-registry.properties
아래 항목의 값을 nifi.properties을 참고하여 수정
nifi.registry.security.keystore=./conf/keystore.jks
nifi.registry.security.keystoreType=jks
nifi.registry.security.keystorePasswd=SLDsRGBxQF6DwltjTYVRaz+Za2x/3p6xqSwpj8Jrqr0
nifi.registry.security.keyPasswd=SLDsRGBxQF6DwltjTYVRaz+Za2x/3p6xqSwpj8Jrqr0
nifi.registry.security.truststore=./conf/truststore.jks
nifi.registry.security.truststoreType=jks
nifi.registry.security.truststorePasswd=3CY5m5Rly3DzNN/K4/wrksJyS+nJaRKcEvz5866ylcQ
```
### 4. authorizers.xml 수정
- userGroupProvider 수정
```xml
    <userGroupProvider>
        <identifier>file-user-group-provider</identifier>
        <class>org.apache.nifi.registry.security.authorization.file.FileUserGroupProvider</class>
        <property name="Users File">./conf/users.xml</property>
        <property name="Initial User Identity 1">CN=admin, OU=winiot</property>
    </userGroupProvider>
```
- accessPolicyProvider 수정
```xml
    <accessPolicyProvider>
        <identifier>file-access-policy-provider</identifier>
        <class>org.apache.nifi.registry.security.authorization.file.FileAccessPolicyProvider</class>
        <property name="User Group Provider">file-user-group-provider</property>
        <property name="Authorizations File">./conf/authorizations.xml</property>
        <property name="Initial Admin Identity">CN=admin, OU=winiot</property>

        <!--<property name="NiFi Identity 1"></property>-->
    </accessPolicyProvider>
```
### 5. identity-providers.xml 수정
```bash
$ vi identity-providers.xml
<provider>
        <identifier>ldap-identity-provider</identifier>
        <class>org.apache.nifi.registry.security.ldap.LdapIdentityProvider</class>
        <property name="Authentication Strategy">SIMPLE</property>

        <property name="Manager DN">cn=admin,dc=winiot,dc=com</property>
        <property name="Manager Password">비밀번호</property>

        <property name="Referral Strategy">FOLLOW</property>
        <property name="Connect Timeout">10 secs</property>
        <property name="Read Timeout">10 secs</property>

        <property name="Url">ldap://{ldap서버 ip}:389</property>
        <property name="User Search Base">ou=nifi,dc=winiot,dc=com</property>
        <property name="User Search Filter">cn={0}</property>

        <property name="Identity Strategy">USE_DN</property>
        <property name="Authentication Expiration">12 hours</property>
    </provider>
# ldap-identity-provider 주석 해제(<!--로 시작하는 부분과 -->끝나는 부분)
# Authentication Strategy : SIMPLE
# Manager DN : cn=admin,dc=winitech,dc=com
# Manageer Password : 관리자계정 암호
# Url : ldap url
# User Search Base : ou=nifi,dc=winitech,dc=com
# User Search Filter : cn={0}
# Identity Strategy : USE_DN
```
### 6. NiFi-Registry 구동
- 실행
```bash
- foreground
$ {NiFi-registry 설치 디렉토리}/bin/nifi-registry.sh run
- background
$ {NiFi-registry 설치 디렉토리}/bin/nifi-registry.sh start
```
- 정지
```bash
- foreground
Ctrl-c를 입력
- background
$ {NiFi-registry 설치 디렉토리}/bin/nifi-registry.sh stop
```
### ※ 참고
- https://www.youtube.com/watch?v=qD03ao3R-a4
- https://www.youtube.com/watch?v=DSO12fhnZ90
- https://192.168.0.37:18443/nifi-registry-docs/documentation
