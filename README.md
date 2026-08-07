# MyWeb 个人网站

前后端一体的个人网站：Vue 3 + Vite 前端，Spring Boot + MySQL 后端，nginx 部署。

## 目录

- `myweb_frontend/` 前端
- `myweb_backend/` 后端
- `deploy/` 部署脚本

## 快速开始

```sh
# 前端
cd myweb_frontend
npm install
npm run dev

# 后端
cd myweb_backend
mvn clean package -DskipTests
java -jar target/myweb-1.0.0.jar
```

## 技术栈

Vue 3 / Vite / Spring Boot 3 / MySQL 8 / Flyway / nginx
