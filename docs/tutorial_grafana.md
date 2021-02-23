# Grafana 설치방법
이 글은 Apache NiFi의 모니터링 대시보드에 사용할 Grafana설치방법에 대해 설명한다. <br/>
- OS : CentOS 7

### 1. Grafana 다운로드
```bash
$ wget https://dl.grafana.com/oss/release/grafana-7.4.2.linux-amd64.tar.gz
```
### 2. 압축해제
```bash
$ tar -zxvf grafana-7.4.2.linux-amd64.tar.gz
```

### 3. 실행
```bash
$ cd grafana-7.4.2/bin
$ ./grafana-server
# 기본 포트 3000 사용
```

### 5. 테스트
- url : http://{설치서버ip}:3000 </br>
웹페이지에 접속에 성공하면 아래와 같은 초기화면이 표시.
<img width='600' src="../image/image42.png"></img><br/>

### 6. Prometheus와의 연동
- Configuration > Data Sources에서 Prometheus 정보 등록.
<img width='600' src="../image/image45.png"></img><br/>