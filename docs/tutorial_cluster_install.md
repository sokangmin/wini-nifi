# NiFi Cluster 설치방법
이 글은 Apache NiFi의 Cluster 설치방법에 대해 설명한다. <br/>
- 선행작업으로 [NiFi 기본설치(Standalone모드)](./tutorial_install.md)가 2대이상으로 미리 설치되어야 한다.<br/>
일단 2대라고 가정하고 설명한다.

### 1. nifi.properties 수정(모든서버 적용)
```properties
nifi.state.management.embedded.zookeeper.start=true

nifi.cluster.protocol.is.secure=true

nifi.cluster.is.node=true
nifi.cluster.flow.election.max.candidates=서버수

nifi.zookeeper.connect.string=호스트명:2181
```
### 2. authorizers.xml 수정(모든서버 적용)
- userGroupProvider 수정
```xml
    <userGroupProvider>
        <identifier>file-user-group-provider</identifier>
        <class>org.apache.nifi.authorization.FileUserGroupProvider</class>
        <property name="Users File">./conf/users.xml</property>
        <property name="Legacy Authorized Users File"></property>

        <property name="Initial User Identity 1">CN=admin, OU=winiot</property>
        <property name="Initial User Identity 2">CN={1번서버 호스트명}, OU=NIFI</property>
        <property name="Initial User Identity 3">CN={2번서버 호스트명}, OU=NIFI</property>
    </userGroupProvider>
```
- accessPolicyProvider 수정
```xml
    <accessPolicyProvider>
        <identifier>file-access-policy-provider</identifier>
        <class>org.apache.nifi.authorization.FileAccessPolicyProvider</class>
        <property name="User Group Provider">file-user-group-provider</property>
        <property name="Authorizations File">./conf/authorizations.xml</property>
        <property name="Initial Admin Identity">CN=admin, OU=winitech</property>
        <property name="Legacy Authorized Users File"></property>
        <property name="Node Identity 1">CN={1번서버 호스트명}, OU=NIFI</property>
        <property name="Node Identity 2">CN={2번서버 호스트명}, OU=NIFI</property>
        <property name="Node Group"></property>
    </accessPolicyProvider>
```
### 3. state-management.xml 수정(모든서버 적용)
```xml
    <cluster-provider>
        <id>zk-provider</id>
        <class>org.apache.nifi.controller.state.providers.zookeeper.ZooKeeperStateProvider</class>
        <property name="Connect String">호스트명:2181</property>
        <property name="Root Node">/nifi</property>
        <property name="Session Timeout">10 seconds</property>
        <property name="Access Control">Open</property>
    </cluster-provider>
```
### 4. zookeeper.property 수정
```properties
server.1={1번서버 호스트명}:2888:3888;2181
server.2={2번서버 호스트명}:2888:3888;2181
```
### 5. zookeeper myid file 생성
