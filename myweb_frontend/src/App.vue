<template>
  <div class="page">
    <!-- 背景装饰：彩色光斑与漂浮星点 -->
    <div class="bg-decor" aria-hidden="true">
      <span class="blob blob-1"></span>
      <span class="blob blob-2"></span>
      <span class="blob blob-3"></span>
      <span class="spark spark-1">✦</span>
      <span class="spark spark-2">✧</span>
      <span class="spark spark-3">✦</span>
      <span class="spark spark-4">·</span>
    </div>

    <!-- 顶部导航：目前仅展示，不绑定点击事件 -->
    <nav class="navbar">
      <div class="logo">✦ My Web</div>
      <div class="nav-items">
        <div class="nav-item" v-for="item in navItems" :key="item.text">
          <span class="nav-emoji">{{ item.emoji }}</span>{{ item.text }}
        </div>
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
        <div class="avatar-ring">
          <img :src="info.photo" alt="头像" />
          <span class="float-badge badge-1">🎓</span>
          <span class="float-badge badge-2">💻</span>
          <span class="float-badge badge-3">🚀</span>
        </div>
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
const navItems = [
  { emoji: '🏫', text: '学习生涯' },
  { emoji: '🎨', text: '个人作品' },
  { emoji: '🛠️', text: '项目设计' },
  { emoji: '📮', text: '联系方式' },
]

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
  background: #f6f7ff;
}

/* ===== 页面容器 ===== */
.page {
  position: relative;
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', 'Comic Sans MS', sans-serif;
  background: linear-gradient(135deg, #f6f7ff 0%, #fdf0f6 45%, #eef6ff 100%);
}

/* ===== 背景装饰 ===== */
.bg-decor {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
  z-index: 0;
}

.blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(70px);
  opacity: 0.55;
  animation: blob-float 16s ease-in-out infinite alternate;
}

.blob-1 {
  width: 420px;
  height: 420px;
  left: -120px;
  top: -80px;
  background: radial-gradient(circle, #c7a8ff 0%, transparent 70%);
}

.blob-2 {
  width: 360px;
  height: 360px;
  right: -100px;
  top: 25%;
  background: radial-gradient(circle, #ffd3ec 0%, transparent 70%);
  animation-delay: -4s;
}

.blob-3 {
  width: 300px;
  height: 300px;
  left: 30%;
  bottom: -120px;
  background: radial-gradient(circle, #bdeaff 0%, transparent 70%);
  animation-delay: -8s;
}

@keyframes blob-float {
  0% {
    transform: translate(0, 0) scale(1);
  }
  100% {
    transform: translate(30px, -30px) scale(1.12);
  }
}

.spark {
  position: absolute;
  color: #8f7bf7;
  opacity: 0.7;
  animation: spark-twinkle 3.5s ease-in-out infinite;
}

.spark-1 {
  font-size: 26px;
  left: 12%;
  top: 22%;
}

.spark-2 {
  font-size: 18px;
  right: 16%;
  top: 15%;
  color: #f48fb1;
  animation-delay: -1.2s;
}

.spark-3 {
  font-size: 22px;
  left: 48%;
  bottom: 18%;
  color: #4fc3f7;
  animation-delay: -2.1s;
}

.spark-4 {
  font-size: 40px;
  right: 32%;
  bottom: 24%;
  color: #ffd54f;
  animation-delay: -0.6s;
}

@keyframes spark-twinkle {
  0%,
  100% {
    opacity: 0.25;
    transform: translateY(0) scale(0.9);
  }
  50% {
    opacity: 0.9;
    transform: translateY(-12px) scale(1.1);
  }
}

/* ===== 顶部导航 ===== */
.navbar {
  position: relative;
  z-index: 2;
  height: 64px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.8);
  box-shadow: 0 4px 24px rgba(124, 58, 237, 0.06);
}

.logo {
  font-size: 20px;
  font-weight: 800;
  letter-spacing: 1px;
  background: linear-gradient(90deg, #7c3aed, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  white-space: nowrap;
}

.nav-items {
  display: flex;
  gap: 8px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 9px 18px;
  border-radius: 999px;
  font-size: 15px;
  font-weight: 600;
  color: #4a4a6a;
  cursor: default;
  transition:
    transform 0.25s ease,
    background 0.25s ease,
    color 0.25s ease,
    box-shadow 0.25s ease;
}

.nav-item:hover {
  color: #7c3aed;
  background: rgba(124, 58, 237, 0.1);
  transform: translateY(-2px);
  box-shadow: 0 6px 18px rgba(124, 58, 237, 0.16);
}

.nav-emoji {
  font-size: 17px;
}

/* ===== 主体：左右并排 ===== */
.main {
  position: relative;
  z-index: 1;
  flex: 1;
  min-height: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6vw;
  padding: 32px 8vw;
}

.left {
  max-width: 520px;
  animation: fade-up 0.8s ease both;
}

.greeting {
  font-size: 24px;
  font-weight: 600;
  color: #6b6b8d;
  margin-bottom: 8px;
  letter-spacing: 1px;
}

.name {
  font-size: clamp(46px, 6vw, 76px);
  font-weight: 900;
  line-height: 1.15;
  background: linear-gradient(120deg, #7c3aed 10%, #ec4899 45%, #f59e0b 90%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin-bottom: 12px;
}

.subtitle {
  font-size: 20px;
  color: #555577;
  margin-bottom: 24px;
  letter-spacing: 0.5px;
}

.tech-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.chip {
  padding: 7px 16px;
  border-radius: 999px;
  font-size: 14px;
  font-weight: 600;
  color: #6d4fd8;
  background: rgba(255, 255, 255, 0.85);
  border: 1.5px solid rgba(124, 58, 237, 0.25);
  box-shadow: 0 4px 14px rgba(124, 58, 237, 0.1);
  animation: fade-up 0.6s ease both;
}

.chip:nth-child(2) {
  animation-delay: 0.12s;
}

.chip:nth-child(3) {
  animation-delay: 0.24s;
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(18px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* ===== 右侧头像 ===== */
.right {
  display: flex;
  justify-content: center;
  align-items: center;
  animation: fade-up 0.9s ease 0.15s both;
}

.avatar-ring {
  position: relative;
  width: min(38vw, 380px);
  aspect-ratio: 1 / 1;
  border-radius: 50%;
  padding: 12px;
  background: conic-gradient(from 0deg, #7c3aed, #ec4899, #f59e0b, #22d3ee, #7c3aed);
  animation: ring-spin 12s linear infinite;
  box-shadow: 0 24px 70px rgba(124, 58, 237, 0.28);
}

.avatar-ring img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
  border: 6px solid #fff;
}

@keyframes ring-spin {
  to {
    transform: rotate(360deg);
  }
}

.float-badge {
  position: absolute;
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
  background: #fff;
  border-radius: 50%;
  box-shadow: 0 10px 28px rgba(0, 0, 0, 0.14);
  animation: badge-bob 3.2s ease-in-out infinite;
}

.badge-1 {
  top: -4px;
  left: 8%;
}

.badge-2 {
  right: -8px;
  top: 42%;
  animation-delay: -1s;
}

.badge-3 {
  bottom: 2%;
  left: 12%;
  animation-delay: -2s;
}

@keyframes badge-bob {
  0%,
  100% {
    transform: translateY(0) rotate(-6deg);
  }
  50% {
    transform: translateY(-10px) rotate(6deg);
  }
}

/* ===== 加载与错误 ===== */
.loading {
  position: relative;
  z-index: 1;
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  font-size: 17px;
  color: #777;
}

.spinner {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  border: 4px solid rgba(124, 58, 237, 0.15);
  border-top-color: #7c3aed;
  animation: spin 0.9s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.load-error {
  color: #e11d48;
  font-weight: 600;
}

.retry-btn {
  padding: 10px 26px;
  border: none;
  border-radius: 999px;
  font-size: 15px;
  font-weight: 700;
  color: #fff;
  cursor: pointer;
  background: linear-gradient(90deg, #7c3aed, #ec4899);
  box-shadow: 0 8px 22px rgba(124, 58, 237, 0.32);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.retry-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 28px rgba(124, 58, 237, 0.4);
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

  .nav-item {
    padding: 7px 14px;
    font-size: 14px;
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

  .avatar-ring {
    width: 190px;
  }

  .float-badge {
    width: 42px;
    height: 42px;
    font-size: 20px;
  }
}
</style>
