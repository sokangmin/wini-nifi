# node export 설치방법
이 글은 Apache NiFi의 모니터링 대시보드에 사용할 prometheus node export설치방법에 대해 설명한다. <br/>
- OS : CentOS 7

### 1. node exporter 다운로드
```bash
$ wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
```
### 2. 압축해제
```bash
$ tar zxvf node_exporter-1.0.1.linux-amd64.tar.gz
```
### 4. 실행
```bash
$ cd node_exporter-1.0.1.linux-amd64
$ ./node_exporter
# 기본포트는 9100으로 설정
```

### 5. 테스트
사전에 Prometheus가 설치되어야 함.
```bash
$ curl http://localhost:9100/metrics | grep "node_"
```

### ※ 참고 블로그
- 참고: https://mycup.tistory.com/320
