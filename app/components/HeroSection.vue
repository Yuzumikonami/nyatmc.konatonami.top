<script setup lang="ts">
const cfg = useAppConfig().nyatmc
</script>

<template>
  <section id="top" class="relative overflow-hidden">
    <!-- 背景光斑 -->
    <div class="pointer-events-none absolute inset-0 -z-10" aria-hidden="true">
      <div class="absolute left-1/2 top-[-12rem] size-[36rem] -translate-x-1/2 rounded-full bg-primary-400/20 blur-3xl dark:bg-primary-500/15" />
      <div class="absolute inset-0 bg-[radial-gradient(to_right,rgba(0,0,0,0.04)_1px,transparent_1px),radial-gradient(to_bottom,rgba(0,0,0,0.04)_1px,transparent_1px)] bg-[size:32px_32px] dark:bg-[radial-gradient(to_right,rgba(255,255,255,0.05)_1px,transparent_1px),radial-gradient(to_bottom,rgba(255,255,255,0.05)_1px,transparent_1px)]" />
    </div>

    <UContainer class="flex flex-col items-center py-24 text-center md:py-32">
      <!-- 标题区 -->
      <div class="animate-fade-in-up flex flex-col items-center">
        <UBadge color="warning" variant="subtle" icon="i-lucide-construction" size="lg">
          开发中 · 阶段 1/9 · daemon 核心
        </UBadge>

        <h1 class="mt-6 text-5xl font-black tracking-tight md:text-7xl">
          <span class="bg-gradient-to-r from-primary-400 via-primary-500 to-indigo-500 bg-clip-text text-transparent dark:from-primary-300 dark:via-primary-400 dark:to-indigo-400">NyaTMC</span>
        </h1>

        <p class="mt-5 max-w-2xl text-lg text-muted md:text-xl">
          用 Go 编写的 <span class="font-semibold text-default">Minecraft 服务器全能管理工具</span>，
          开服、管服、备份全部收进一个可执行文件喵～
        </p>

        <div class="mt-6 flex flex-wrap items-center justify-center gap-2">
          <UBadge v-for="t in ['单二进制', '零依赖', 'CLI 脚本接口','Tui支持', '跨平台']" :key="t" color="primary" variant="subtle" size="lg">{{ t }}</UBadge>
        </div>

        <div class="mt-10 flex flex-wrap items-center justify-center gap-3">
          <UButton href="#install" icon="i-lucide-download" label="立即安装" size="xl" trailing-icon="i-lucide-arrow-down" />
          <UButton :to="cfg.github" target="_blank" icon="i-simple-icons-github" label="GitHub" size="xl" variant="outline" color="neutral" />
        </div>
      </div>

      <!-- TUI 界面预览 -->
      <div class="animate-fade-in-delayed mt-16 w-full max-w-3xl">
        <div class="overflow-hidden rounded-xl border border-default shadow-2xl shadow-primary-500/10">
          <div class="flex items-center gap-2 border-b border-default bg-elevated px-4 py-2.5">
            <span class="size-3 rounded-full bg-red-400/80" aria-hidden="true" />
            <span class="size-3 rounded-full bg-yellow-400/80" aria-hidden="true" />
            <span class="size-3 rounded-full bg-green-400/80" aria-hidden="true" />
            <span class="ml-2 font-mono text-xs text-muted">nyatmc — tui</span>
          </div>
          <!-- eslint-disable-next-line vue/no-v-html -->
          <pre class="overflow-x-auto bg-zinc-950 p-5 font-mono text-xs leading-relaxed text-zinc-300 md:text-sm dark:bg-black/80"><code>┌─ nyatmc ── [survival] ── <span class="text-green-400">● running</span> ──────────────┐
│                                                    │
│  [12:00:01] Starting minecraft server...           │
│  [12:00:03] <span class="text-zinc-100">Done (2.1s)! For help, type "help"</span>    │
│  [12:00:05] <span class="text-yellow-300">Steve joined the game</span>                │
│                                                    │
│  <span class="text-primary-400">&gt; say hello</span><span class="inline-block h-4 w-2 translate-y-0.5 animate-pulse bg-primary-400/80"></span>                                     │
├────────────────────────────────────────────────────┤
│  <span class="text-zinc-500">Tab</span>:instances  <span class="text-zinc-500">b</span>:backup  <span class="text-zinc-500">R</span>:restore  <span class="text-zinc-500">t</span>:tunnel  <span class="text-zinc-500">q</span>:quit │
└────────────────────────────────────────────────────┘</code></pre>
        </div>
        <p class="mt-3 text-xs text-dimmed">TUI 主界面预览：日志流 · 命令输入 · 实例切换（渲染效果以实际版本为准）</p>
      </div>
    </UContainer>
  </section>
</template>
