# NiFi 기본설치방법
이 글은 Apache NiFi의 기본설치방법에 대해 설명한다. <br/>
- OS : CentOS 7
- Apache Nifi : 1.11.4

### 1. nifi계정을 생성한다.
- root 계정으로 접속 <br/>
- nifi 계정 생성 <br/>
#> groupadd nifi <br/>
#> useradd -g nifi nifi <br/>
#> passwd nifi <br/>
- nifi 계정으로 재접속

