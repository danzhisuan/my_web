-- ============================================================
-- V1: 初始化个人网站数据库结构与种子数据
-- 由 Flyway 在应用启动时自动执行（只执行一次，勿手动修改）
-- ============================================================

CREATE TABLE site_profile (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
    name        VARCHAR(50)  NOT NULL COMMENT '姓名/昵称',
    title       VARCHAR(100) NOT NULL DEFAULT '你好，我是' COMMENT '问候语',
    subtitle    VARCHAR(100) DEFAULT NULL COMMENT '副标题/身份介绍',
    tech        VARCHAR(255) DEFAULT NULL COMMENT '技术栈（以 + 分隔）',
    photo_path  VARCHAR(255) DEFAULT NULL COMMENT '照片访问路径',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '个人网站档案';

-- 种子数据（保持与现有页面展示一致，可随时在数据库修改）
INSERT INTO site_profile (name, title, subtitle, tech, photo_path)
VALUES ('胆汁酸', '你好，我是', '一名个人全栈开发者', 'Spring Boot + Vue + MySQL', '/api/photo/profile.jpg');
