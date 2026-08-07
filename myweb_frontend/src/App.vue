<template>
  <div class="page">
    <!-- 顶部导航：目前仅展示，不绑定点击事件 -->
    <nav class="navbar">
      <div class="logo">{{ siteTitle }}</div>
      <div class="nav-items">
        <div class="nav-item" v-for="item in navItems" :key="item">{{ item }}</div>
      </div>
    </nav>

    <!-- 主体：左右并排 -->
    <main class="main" v-if="info">
      <div class="left">
        <p class="greeting">{{ info.title }}</p>
        <h1 class="name">{{ info.name }}</h1>
        <p class="subtitle">{{ info.subtitle }}</p>
        <div class="tech-chips">
          <span class="chip" v-for="t in techList" :key="t">{{ t }}</span>
        </div>
      </div>

      <div class="right">
        <img :src="info.photo" alt="头像" />
      </div>
    </main>

    <div v-else class="loading">
      <div v-if="!loadError" class="spinner"></div>
      <p v-if="!loadError">加载中...</p>
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
  background: #f5f7fa;
}

/* ===== 页面容器 ===== */
.page {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f7fa;
  font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
  overflow: hidden;
}

/* ===== 顶部导航 ===== */
.navbar {
  height: 64px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  background: #fff;
  border-bottom: 1px solid #e5e7eb;
}

.logo {
  font-size: 18px;
  font-weight: 700;
  color: #1f2937;
  white-space: nowrap;
}

.nav-items {
  display: flex;
  gap: 8px;
}

.nav-item {
  padding: 8px 16px;
  font-size: 15px;
  color: #4b5563;
  cursor: default;
  border-radius: 6px;
  transition: color 0.2s ease, background 0.2s ease;
}

.nav-item:hover {
  color: #4f46e5;
  background: #eef2ff;
}

/* ===== 主体：左右并排 ===== */
.main {
  flex: 1;
  min-height: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8vw;
  padding: 32px 8vw;
}

.left {
  max-width: 480px;
}

.greeting {
  font-size: 20px;
  color: #6b7280;
  margin-bottom: 6px;
}

.name {
  font-size: 56px;
  font-weight: 800;
  color: #111827;
  line-height: 1.2;
  margin-bottom: 8px;
}

.subtitle {
  font-size: 18px;
  color: #6b7280;
  margin-bottom: 24px;
}

.tech-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.chip {
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 13px;
  color: #4f46e5;
  background: #fff;
  border: 1px solid #e5e7eb;
}

/* ===== 右侧头像 ===== */
.right {
  display: flex;
  justify-content: center;
  align-items: center;
}

.right img {
  width: min(36vw, 360px);
  aspect-ratio: 1 / 1;
  border-radius: 50%;
  object-fit: cover;
  border: 4px solid #fff;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

/* ===== 加载与错误 ===== */
.loading {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  font-size: 16px;
  color: #6b7280;
}

.spinner {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 3px solid #e5e7eb;
  border-top-color: #4f46e5;
  animation: spin 0.9s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.load-error {
  color: #dc2626;
  font-weight: 600;
}

.retry-btn {
  padding: 9px 24px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  cursor: pointer;
  background: #4f46e5;
  transition: background 0.2s ease;
}

.retry-btn:hover {
  background: #4338ca;
}

/* ===== 窄屏适配 ===== */
@media (max-width: 860px) {
  .navbar {
    height: auto;
    flex-direction: column;
    gap: 8px;
    padding: 12px 16px;
  }

  .nav-items {
    flex-wrap: wrap;
    justify-content: center;
  }

  .main {
    flex-direction: column-reverse;
    gap: 28px;
    padding: 24px;
    justify-content: center;
  }

  .left {
    text-align: center;
  }

  .tech-chips {
    justify-content: center;
  }

  .right img {
    width: 180px;
  }
}
</style>
