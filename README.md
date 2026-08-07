# MyWeb 个人网站

基于服务器部署的前后端个人网站：Vue 3 + Vite 前端，Spring Boot (Java 17) 后端，MySQL 8 数据库，nginx 反向代理。

## 目录结构

```
myweb_frontend/         前端（Vue 3 + Vite）
myweb_backend/          后端（Spring Boot + JPA + Flyway）
deploy/                 部署脚本（建库脚本、systemd 环境文件模板）
```

## 技术栈

- 前端：Vue 3.5、Vite 8
- 后端：Spring Boot 3.2、Spring Data JPA、Flyway 9、MySQL 8
- 部署：nginx 反向代理 + systemd 服务托管

## 本地开发

### 前端

```sh
cd myweb_frontend
npm install
npm run dev        # 开发
npm run build      # 构建到 dist/
```

### 后端

```sh
cd myweb_backend
mvn clean package -DskipTests
java -jar target/myweb-1.0.0.jar
```

后端默认从 `jdbc:mysql://127.0.0.1:3306/myweb` 读取数据，
可通过环境变量 `MYWEB_DB_URL` / `MYWEB_DB_USER` / `MYWEB_DB_PASSWORD` 覆盖。
数据库表结构由 Flyway 迁移管理（`src/main/resources/db/migration/`），禁止手动改表。

## 服务器部署

1. 建库建账号：`sudo mysql < deploy/db/01_create_database.sql`
2. 后端以 systemd 服务运行（`myweb.service`），数据库密码放在 `/etc/myweb/myweb.env`（权限 600）
3. 前端构建产物上传到 `/home/huangyuwei/myweb_frontend/dist`，由 nginx 提供并反向代理 `/api/` 到后端 8081

## 安全说明

- 数据库密码不提交到代码仓库，保存在本机桌面 `服务器.txt` 与服务器 `/etc/myweb/myweb.env`
- MySQL 仅监听 `127.0.0.1`，远程访问请通过 SSH 隧道（如 Navicat SSH 连接）
