<template>
  <div class="page">
    <!-- 顶部导航：目前仅展示，不绑定点击事件 -->
    <nav class="navbar">
      <div class="logo">{{ siteTitle }}</div>
      <div class="nav-items">
        <div class="nav-item" v-for="item in navItems" :key="item">{{ item }}</div>
      </div>
    </nav>

    <!-- 主体：居中排布 -->
    <main class="main" v-if="info">
      <div class="hero">
        <div class="avatar">
          <img :src="info.photo" alt="头像" />
        </div>
        <p class="greeting">{{ info.title }}</p>
        <h1 class="name">{{ info.name }}</h1>
        <p class="subtitle">{{ info.subtitle }}</p>
        <div class="tech-chips">
          <span class="chip" v-for="t in techList" :key="t">{{ t }}</span>
        </div>
      </div>
    </main>

    <div v-else class="loading">
      <div v-if="!loadError" class="spinner"></div>
      <p v-if="!loadError">加载中…</p>
      <p v-else class="load-error">加载失败，请稍后重试</p>
      <button v-if="loadError" class="retry-btn" @click="loadInfo">重试</button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

// 导航项：当前仅展示，后续可绑定路由或锚点
const navItems = ['学习生涯', '个人作品', '项目设计', '联系方式']

const info = ref(null)
const loadError = ref(false)

async function loadInfo() {
  loadError.value = false
  try {
    const res = await fetch('/api/info')
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    info.value = await res.json()
  } catch (err) {
    console.error('加载失败', err)
    loadError.value = true
  }
}

onMounted(loadInfo)

const siteTitle = computed(() =>
  info.value && info.value.name ? `${info.value.name}的个人网页` : '个人网页'
)

const techList = computed(() => {
  if (!info.value || !info.value.tech) return ['Spring Boot', 'Vue', 'MySQL']
  return info.value.tech.split(' + ').map((t) => t.trim())
})
</script>

<style>
/* ===== 设计令牌（Apple 风格，跟随系统深浅色） ===== */
:root {
  --bg: #f5f5f7;
  --text: #1d1d1f;
  --text-secondary: #6e6e73;
  --accent: #0071e3;
  --nav-bg: rgba(255, 255, 255, 0.72);
  --nav-border: rgba(0, 0, 0, 0.08);
  --chip-bg: #e8e8ed;
  --chip-hover: #d2d2d7;
  --avatar-shadow: 0 12px 40px rgba(0, 0, 0, 0.12);
  --font-sans: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text',
    'Helvetica Neue', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #000000;
    --text: #f5f5f7;
    --text-secondary: #86868b;
    --accent: #2997ff;
    --nav-bg: rgba(22, 22, 23, 0.72);
    --nav-border: rgba(255, 255, 255, 0.1);
    --chip-bg: #1d1d1f;
    --chip-hover: #2c2c2e;
    --avatar-shadow: 0 12px 40px rgba(0, 0, 0, 0.5);
  }
}

/* ===== 全局重置 ===== */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html,
body {
  width: 100%;
  height: 100%;
  overflow: hidden;
  background: var(--bg);
  color-scheme: light dark;
}

/* ===== 页面容器 ===== */
.page {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--bg);
  font-family: var(--font-sans);
  color: var(--text);
  overflow: hidden;
  transition: background 0.3s ease, color 0.3s ease;
}

/* ===== 顶部导航 ===== */
.navbar {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 10;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 22px;
  background: var(--nav-bg);
  backdrop-filter: saturate(180%) blur(20px);
  -webkit-backdrop-filter: saturate(180%) blur(20px);
  border-bottom: 1px solid var(--nav-border);
}

.logo {
  font-size: 17px;
  font-weight: 600;
  letter-spacing: -0.01em;
  white-space: nowrap;
}

.nav-items {
  display: flex;
  gap: 4px;
}

.nav-item {
  padding: 6px 14px;
  font-size: 14px;
  color: var(--text);
  cursor: default;
  border-radius: 6px;
  transition: color 0.2s ease, background 0.2s ease;
}

.nav-item:hover {
  color: var(--accent);
  background: rgba(0, 0, 0, 0.04);
}

/* ===== 主体：居中排布 ===== */
.main {
  flex: 1;
  min-height: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 72px 24px 40px;
}

.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  max-width: 720px;
}

.avatar {
  margin-bottom: 28px;
  animation: fade-up 0.8s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.avatar img {
  display: block;
  width: 132px;
  aspect-ratio: 1 / 1;
  border-radius: 50%;
  object-fit: cover;
  box-shadow: var(--avatar-shadow);
}

.greeting {
  font-size: 19px;
  color: var(--text-secondary);
  margin-bottom: 6px;
  animation: fade-up 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.08s both;
}

.name {
  font-size: clamp(44px, 7vw, 76px);
  font-weight: 600;
  line-height: 1.1;
  letter-spacing: -0.02em;
  color: var(--text);
  margin-bottom: 10px;
  animation: fade-up 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.16s both;
}

.subtitle {
  font-size: 21px;
  color: var(--text-secondary);
  margin-bottom: 32px;
  animation: fade-up 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.24s both;
}

.tech-chips {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 10px;
  animation: fade-up 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.32s both;
}

.chip {
  padding: 8px 18px;
  border-radius: 980px;
  font-size: 14px;
  font-weight: 500;
  color: var(--text);
  background: var(--chip-bg);
  transition: background 0.2s ease, transform 0.2s ease;
}

.chip:hover {
  background: var(--chip-hover);
  transform: translateY(-1px);
}

/* ===== 加载与错误 ===== */
.loading {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 18px;
  font-size: 15px;
  color: var(--text-secondary);
}

.spinner {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 3px solid rgba(0, 0, 0, 0.1);
  border-top-color: var(--text-secondary);
  animation: spin 0.9s linear infinite;
}

@media (prefers-color-scheme: dark) {
  .spinner {
    border-color: rgba(255, 255, 255, 0.15);
    border-top-color: var(--text-secondary);
  }
}

.load-error {
  color: var(--text-secondary);
  font-weight: 600;
}

.retry-btn {
  padding: 10px 26px;
  border: none;
  border-radius: 980px;
  font-size: 15px;
  font-weight: 500;
  color: #fff;
  cursor: pointer;
  background: var(--accent);
  transition: opacity 0.2s ease;
}

.retry-btn:hover {
  opacity: 0.85;
}

/* ===== 动画 ===== */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(14px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* ===== 窄屏适配 ===== */
@media (max-width: 720px) {
  .navbar {
    height: auto;
    padding: 12px 16px;
  }

  .avatar img {
    width: 104px;
  }

  .name {
    font-size: clamp(36px, 11vw, 52px);
  }

  .subtitle {
    font-size: 18px;
  }
}

/* ===== 减少动效偏好 ===== */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.001ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.001ms !important;
  }
}
</style>
