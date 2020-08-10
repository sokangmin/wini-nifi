# NiFi 기본설치방법
이 글은 Apache NiFi의 기본설치방법에 대해 설명한다. <br/>
- OS : CentOS 7
- Apache Nifi : 1.11.4

### 1. nifi계정을 생성한다.
- root 계정으로 접속 <br/>
- nifi 계정 생성 <br/>
```bash
$ groupadd nifi 
$ useradd -g nifi nifi
$ passwd nifi
```
- nifi 계정으로 재접속

### 2. JDK를 다운로드하고 환경변수를 등록한다.
- jdk 다운로드 url : https://www.oracle.com/java/technologies/javase-jdk11-downloads.html <br/>
#> tar
