# Apache NiFi 와 LDAP 연동방법
이 글은 Apache NiFi의 인증을 위해 LDAP과 연동하는 방법에 대해 설명한다. <br/>
- 선행작업으로 [NiFi 기본설치(Standalone모드)](./tutorial_install.md), [LDAP 설치](./tutorial_ldap.md)가 미리 완료되어야 한다. <br/>
### 1. nifi.properties 수정
```properties
$ vi {NiFi 설치디렉토리}/conf/nifi.properties
nifi.security.user.login.identity.provider=ldap-provider
```
### 2. login-identity-providers.xml 수정
```xml
$ vi {NiFi 설치디렉토리}/conf/login-identity-providers.xml
<provider>
      <identifier>ldap-provider</identifier>
      <class>org.apache.nifi.ldap.LdapProvider</class>
      <property name="Authentication Strategy">SIMPLE</property>

      <property name="Manager DN">cn=admin,dc=winiot,dc=com</property>
      <property name="Manager Password">패스워드</property>

      <property name="TLS - Keystore"></property>
      <property name="TLS - Keystore Password"></property>
      <property name="TLS - Keystore Type"></property>
      <property name="TLS - Truststore"></property>
      <property name="TLS - Truststore Password"></property>
      <property name="TLS - Truststore Type"></property>
      <property name="TLS - Client Auth"></property>
      <property name="TLS - Protocol"></property>
      <property name="TLS - Shutdown Gracefully"></property>

      <property name="Referral Strategy">FOLLOW</property>
      <property name="Connect Timeout">10 secs</property>
      <property name="Read Timeout">10 secs</property>

      <property name="Url">ldap://192.168.0.37:389</property>
      <property name="User Search Base">ou=nifi,dc=winiot,dc=com</property>
      <property name="User Search Filter">cn={0}</property>

      <property name="Identity Strategy">USE_DN</property>
      <property name="Authentication Expiration">12 hours</property>
  </provider>
※ ldap-provider의 주석 해제(<!--로 시작하는 부분과 -->끝나는 부분)
※ Authentication Strategy : SIMPLE
※ Manager DN : cn=admin,dc=winiot,dc=com
※ Manageer Password : 관리자계정 암호
※ Url : ldap url
※ User Search Base : ou=nifi,dc=winiot,dc=com
※ User Search Filter : cn={0}
※ Identity Strategy : USE_DN
```
### 3. NiFi 재구동
