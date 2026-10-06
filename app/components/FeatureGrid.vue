<script setup lang="ts">
type FeatureStatus = 'dev' | 'plan'

interface Feature {
  icon: string
  title: string
  desc: string
  status: FeatureStatus
}

const features: Feature[] = [
  { icon: 'i-lucide-server', title: '实例管理', desc: '创建 / 启动 / 停止 / 重启 / 状态查询，多实例统一管理', status: 'dev' },
  { icon: 'i-lucide-shield-check', title: '进程守护', desc: '跨平台子进程管理、优雅关闭、看门狗自动重启', status: 'dev' },
  { icon: 'i-lucide-terminal', title: '实时 TUI', desc: '日志流、命令输入、TPS / 内存 / 玩家信息面板、多实例切换', status: 'dev' },
  { icon: 'i-lucide-archive', title: '备份恢复', desc: 'tar.gz 打包、自动轮转、带确认的一键恢复', status: 'plan' },
  { icon: 'i-lucide-clock', title: '定时调度', desc: 'cron 表达式定时备份、定时重启', status: 'plan' },
  { icon: 'i-lucide-download', title: '服务端下载', desc: 'Paper / Fabric / Spigot 自动拉取 + SHA256 校验', status: 'plan' },
  { icon: 'i-lucide-globe', title: '内网穿透', desc: '一键 Cloudflare Tunnel，状态栏直显公网地址', status: 'plan' },
  { icon: 'i-lucide-layout-dashboard', title: 'Web 面板', desc: '浏览器实时日志 + 远程控制，SSE 推送', status: 'plan' },
  { icon: 'i-lucide-refresh-cw', title: '自动更新', desc: '基于 GitHub Release 自更新，保持最新版本', status: 'plan' },
]

const platformNotes = [
  { icon: 'i-simple-icons-linux', label: 'Linux', detail: 'amd64 / arm64' },
  { icon: 'i-simple-icons-windows', label: 'Windows', detail: 'Job Object' },
  { icon: 'i-simple-icons-android', label: 'Android · Termux', detail: '纯子进程，不依赖 systemd' },
]
</script>

<template>
  <section id="features" class="border-t border-default py-24">
    <UContainer>
      <div class="mx-auto max-w-2xl text-center">
        <p class="font-mono text-sm font-semibold text-primary-500">// 特性</p>
        <h2 class="mt-2 text-3xl font-bold tracking-tight md:text-4xl">一个二进制，管好整个服务器</h2>
        <p class="mt-3 text-muted">
          TUI 是一等公民，CLI 为脚本接口，Web 为远程补充 —— 三层 UI 共享同一套业务核心。
        </p>
      </div>

      <!-- 特性网格 -->
      <div class="mt-14 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <div
          v-for="f in features"
          :key="f.title"
          class="group rounded-card border border-default bg-elevated/40 p-5 transition-colors hover:border-primary-500/50 hover:bg-elevated/70"
        >
          <div class="flex items-start justify-between gap-3">
            <div class="flex size-11 shrink-0 items-center justify-center rounded-lg bg-primary-500/10 text-primary-500">
              <UIcon :name="f.icon" class="size-6" />
            </div>
            <UBadge :color="f.status === 'dev' ? 'warning' : 'neutral'" variant="subtle" size="sm">
              {{ f.status === 'dev' ? '开发中' : '计划' }}
            </UBadge>
          </div>
          <h3 class="mt-4 text-base font-semibold">{{ f.title }}</h3>
          <p class="mt-1.5 text-sm leading-relaxed text-muted">{{ f.desc }}</p>
        </div>
      </div>

      <!-- 架构设计 -->
      <div class="mt-14 grid items-center gap-8 lg:grid-cols-2">
        <div>
          <p class="font-mono text-sm font-semibold text-primary-500">// 设计哲学</p>
          <h3 class="mt-2 text-2xl font-bold">TUI 本质是壳，<code class="rounded bg-elevated px-1.5 py-0.5 font-mono text-lg text-primary-500">internal/app</code> 才是真相源</h3>
          <p class="mt-3 text-sm leading-relaxed text-muted">
            分层依赖严格单向：CLI（Cobra）、TUI（Bubble Tea）、Web（Gin）三个壳互不导入，
            全部业务逻辑沉淀在 <span class="font-mono">internal/app</span>，操作的是磁盘上同一份实例数据（<span class="font-mono">~/.nyatmc/</span>）。
          </p>
          <ul class="mt-4 space-y-2 text-sm text-muted">
            <li class="flex items-center gap-2"><UIcon name="i-lucide-check" class="size-4 text-primary-500" /> UI 层禁止写业务逻辑，只调用 app 并把结果可视化</li>
            <li class="flex items-center gap-2"><UIcon name="i-lucide-check" class="size-4 text-primary-500" /> Unix 用 Setpgid 杀进程组，Windows 用 Job Object</li>
            <li class="flex items-center gap-2"><UIcon name="i-lucide-check" class="size-4 text-primary-500" /> 全平台纯子进程运行，Termux 也能开服</li>
          </ul>
        </div>
        <div class="rounded-card border border-default bg-elevated/40 p-5">
          <!-- eslint-disable-next-line vue/no-v-html -->
          <pre class="overflow-x-auto font-mono text-xs leading-relaxed text-muted md:text-sm"><code>main.go
  ↓
cmd/ (Cobra)   tui/ (Bubble Tea)   web/ (Gin)
  ↓                ↓                  ↓
        <span class="text-primary-500 font-semibold">internal/app/</span>  ← 唯一业务入口
                ↓
daemon / config / backup / scheduler / downloader
                ↓
          pkg/ (logger · procutil)</code></pre>
        </div>
      </div>

      <!-- 跨平台 -->
      <div class="mt-14 flex flex-wrap items-center justify-center gap-3">
        <div
          v-for="p in platformNotes"
          :key="p.label"
          class="flex items-center gap-2.5 rounded-full border border-default bg-elevated/40 px-4 py-2 text-sm"
        >
          <UIcon :name="p.icon" class="size-4 text-primary-500" />
          <span class="font-medium">{{ p.label }}</span>
          <span class="text-dimmed">{{ p.detail }}</span>
        </div>
      </div>
    </UContainer>
  </section>
</template>
