-- ============================================================
-- 创建数据库与应用账号（需以 root 权限执行，仅执行一次）
-- 用法：sudo mysql < 01_create_database.sql
-- 注意：真实密码保存在服务器 /etc/myweb/myweb.env 与本机桌面 服务器.txt，
--       此处使用占位符，请勿把真实密码提交到代码仓库。
-- ============================================================

CREATE DATABASE IF NOT EXISTS myweb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

-- 应用专用账号：只授予业务库的最小权限，不用 root 连接
CREATE USER IF NOT EXISTS 'myweb'@'localhost' IDENTIFIED BY 'CHANGE_ME_STRONG_PASSWORD';
ALTER USER 'myweb'@'localhost' IDENTIFIED BY 'CHANGE_ME_STRONG_PASSWORD';

-- Flyway 建表需要 DDL 权限，因此授予该业务库的全部权限（仅限 myweb 库、仅本机）
GRANT ALL PRIVILEGES ON myweb.* TO 'myweb'@'localhost';

FLUSH PRIVILEGES;
