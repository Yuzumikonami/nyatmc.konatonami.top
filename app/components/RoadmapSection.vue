<script setup lang="ts">
type StageStatus = 'done' | 'doing' | 'todo'

interface Stage {
  id: number
  name: string
  desc: string
  status: StageStatus
}

const stages: Stage[] = [
  { id: 0, name: '地基', desc: 'go.mod、版本号、配置加载', status: 'done' },
  { id: 1, name: 'daemon 核心', desc: '进程启停、日志管道、跨平台处理', status: 'doing' },
  { id: 2, name: 'app 服务层', desc: 'Manager / Instance / 事件总线', status: 'doing' },
  { id: 3, name: 'TUI MVP', desc: '日志 + 命令 + 启停', status: 'todo' },
  { id: 4, name: 'TUI 完整版', desc: '信息面板 / 多实例 / 全快捷键', status: 'todo' },
  { id: 5, name: '备份 / 恢复', desc: 'tar.gz 打包、自动轮转、一键恢复', status: 'todo' },
  { id: 6, name: 'CLI 全量对齐', desc: 'Cobra 壳，所有 TUI 功能有 CLI 对应', status: 'todo' },
  { id: 7, name: '调度器 + 下载器', desc: 'cron 定时任务 + 服务端自动拉取', status: 'todo' },
  { id: 8, name: 'Cloudflare Tunnel', desc: '一键内网穿透', status: 'todo' },
  { id: 9, name: 'Web 仪表盘', desc: '浏览器实时日志 + 远程控制（可选）', status: 'todo' },
]

const statusMeta: Record<StageStatus, { icon: string; label: string; class: string }> = {
  done: { icon: 'i-lucide-circle-check', label: '已完成', class: 'text-green-500' },
  doing: { icon: 'i-lucide-loader-circle', label: '进行中', class: 'text-primary-500' },
  todo: { icon: 'i-lucide-circle-dashed', label: '计划', class: 'text-dimmed' },
}

const cfg = useAppConfig().nyatmc
const counts = {
  done: stages.filter(s => s.status === 'done').length,
  doing: stages.filter(s => s.status === 'doing').length,
  todo: stages.filter(s => s.status === 'todo').length,
}
</script>

<template>
  <section id="roadmap" class="border-t border-default py-24">
    <UContainer>
      <div class="mx-auto max-w-2xl text-center">
        <p class="font-mono text-sm font-semibold text-primary-500">// 路线图</p>
        <h2 class="mt-2 text-3xl font-bold tracking-tight md:text-4xl">分阶段推进，每一步都能跑</h2>
        <p class="mt-3 text-muted">前一阶段不通过，不进下一阶段。进度详情见仓库 <a :href="`${cfg.github}/blob/main/goal.md`" target="_blank" class="text-primary-500 hover:underline">goal.md</a> 喵～</p>
      </div>

      <!-- 进度概览 -->
      <div class="mx-auto mt-10 grid max-w-2xl grid-cols-3 gap-4">
        <div class="rounded-card border border-default bg-elevated/40 p-4 text-center">
          <p class="text-3xl font-black text-green-500">{{ counts.done }}</p>
          <p class="mt-1 text-xs text-muted">已完成</p>
        </div>
        <div class="rounded-card border border-default bg-elevated/40 p-4 text-center">
          <p class="text-3xl font-black text-primary-500">{{ counts.doing }}</p>
          <p class="mt-1 text-xs text-muted">进行中</p>
        </div>
        <div class="rounded-card border border-default bg-elevated/40 p-4 text-center">
          <p class="text-3xl font-black text-dimmed">{{ counts.todo }}</p>
          <p class="mt-1 text-xs text-muted">计划中</p>
        </div>
      </div>

      <!-- 阶段时间线 -->
      <ol class="mx-auto mt-14 max-w-3xl space-y-0">
        <li
          v-for="(s, i) in stages"
          :key="s.id"
          class="relative flex gap-4 pb-8 last:pb-0"
        >
          <!-- 连接线 -->
          <div v-if="i < stages.length - 1" class="absolute left-[1.375rem] top-11 h-[calc(100%-2rem)] w-px bg-default" aria-hidden="true" />
          <div class="flex size-11 shrink-0 items-center justify-center rounded-full border border-default bg-default">
            <UIcon :name="statusMeta[s.status].icon" :class="['size-5', statusMeta[s.status].class, s.status === 'doing' ? 'animate-spin' : '']" />
          </div>
          <div class="flex flex-1 flex-wrap items-center gap-x-3 gap-y-1 pt-2">
            <span class="font-mono text-sm text-dimmed">阶段 {{ s.id }}</span>
            <h3 class="text-base font-semibold">{{ s.name }}</h3>
            <UBadge :color="s.status === 'done' ? 'success' : s.status === 'doing' ? 'primary' : 'neutral'" variant="subtle" size="sm">
              {{ statusMeta[s.status].label }}
            </UBadge>
            <p class="w-full text-sm text-muted">{{ s.desc }}</p>
          </div>
        </li>
      </ol>
    </UContainer>
  </section>
</template>
