# NiFi 기본설치방법
이 글은 Apache NiFi의 기본설치방법에 대해 설명한다. <br/>
- OS : CentOS 7
- Apache Nifi : 1.11.4
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
$ tar -xzvf jdk-11.0.6_linux-x64_bin.tar.gz
$ vi .bash_profile
export JAVA_HOME=/home/nifi/jdk-11.0.6
PATH=$JAVA_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin
```
### 3. Apache NiFi Binary파일을 다운로드하고 압축을 해제한다.
- NiFi 다운로드 url : https://nifi.apache.org/download.html
```bash
$ wget http://apache.mirror.cdnetworks.com/nifi/1.11.4/nifi-1.11.4-bin.tar.gz
$ tar -xzvf nifi-1.11.4-bin.tar.gz
```
### 4. NiFi를 구동한다.
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
  
