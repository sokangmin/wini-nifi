# LDAP 설치방법
이 글은 Apache NiFi의 인증에 사용할 OpenLDAP설치방법에 대해 설명한다. <br/>
- OS : CentOS 7

### 1. OpenLDAP 패키지 설치
```bash
$ yum install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel
```
### 2. OpenLDAP 서비스 활성화 및 초기화
```bash
$ systemctl enable slapd
$ systemctl start slapd
```
### 3. OpenLDAP 서버 설정
- 관리자 암호 생성
```bash
$ slappasswd -h {SSHA} -s 암호
```
- OpenLDAP 구성파일 생성
```bash
$ vi conf.ldif
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=winiot,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=admin,dc=winiot,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}/7bxMHI9x/B0blngajlbx7its/Fvlgq+
```
※ olcRootPW는 위에서 생성된 관리자 암호 입력
- 구성파일 적용
```bash
$ ldapmodify -Y EXTERNAL -H ldapi:/// -f conf.ldif
```
### 4. OpenLDAP 데이터베이스 구성
- 샘플 DB 복사 및 권한 부여
```bash
$ cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
$ chown ldap:ldap /var/lib/ldap/*
```
- 스키마 적용
```bash
$ ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
$ ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
$ ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
```
- 디렉토리 구조 구성파일 생성
```bash
$ vi base.ldif
dn: dc=winiot,dc=com
dc: winiot
objectClass: top
objectClass: domain

dn: cn=admin,dc=winiot,dc=com
objectClass: organizationalRole
cn: admin
description: LDAP Manager

dn: ou=nifi,dc=winiot,dc=com
objectClass: organizationalUnit
ou: nifi
```
- 구성파일 적용
```bash
$ ldapadd -x -W -D "cn=admin,dc=winiot,dc=com" -f base.ldif
```
### 5. OpenLDAP 사용자 생성
- 사용자 구성파일 생성
```bash
$ vi newuser.ldif
dn: uid=hikkin,ou=nifi,dc=winiot,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: hikkin
uid: hikkin
uidNumber: 9999
gidNumber: 100
homeDirectory: /home/root
loginShell: /bin/bash
gecos: hikkin
userPassword: {crypt}x
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7
```
- 구성파일 적용
```bash
$ ldapadd -x -W -D "cn=admin,dc=winitech,dc=com" -f newuser.ldif
```
- 암호 설정
```bash
$ ldappasswd -s 암호 -W -D "cn=admin,dc=winiot,dc=com" -x "uid=hikkin,ou=nifi,dc=winiot,dc=com"
```
### 6. 테스트
```bash
$ ldapsearch -x cn=admin -b dc=winiot,dc=com
사용자정보가 표시되면 정상
```
### ※ LDAP 관리도구 및 참고
- 무료: http://www.ldapadmin.org/
- 상용: https://www.ldapsoft.com/download.html
- 참고: https://travel-nomad.tistory.com/21?category=784038
