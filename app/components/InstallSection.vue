<script setup lang="ts">
import type { Platform } from '~/composables/usePlatform'

const cfg = useAppConfig().nyatmc
const { platform, detected } = usePlatform()

/** 当前选中的平台；null = 尚未确定（SSR / 骨架屏阶段） */
const selected = ref<Platform | null>(null)
/** 是否仍处于"自动检测"状态（用户手动切换后置 false，隐藏提示条） */
const auto = ref(true)

onMounted(() => {
  selected.value = platform.value
})

function select(p: Platform) {
  selected.value = p
  auto.value = false
}

const tabs: { id: Platform; label: string; icon: string }[] = [
  { id: 'windows', label: 'Windows', icon: 'i-simple-icons-windows' },
  { id: 'macos', label: 'macOS', icon: 'i-simple-icons-apple' },
  { id: 'linux', label: 'Linux / Termux', icon: 'i-simple-icons-linux' },
]

const platformName: Record<Platform, string> = {
  windows: 'Windows',
  macos: 'macOS',
  linux: 'Linux / Termux',
}

/** 各平台一键安装命令 */
const commands: Record<Platform, string> = {
  windows: `irm ${cfg.installPs1Url} | iex`,
  macos: `curl -fsSL ${cfg.installShUrl} | bash`,
  linux: `curl -fsSL ${cfg.installShUrl} | bash`,
}

/** 命令运行环境提示 */
const shellNote: Record<Platform, string> = {
  windows: '在 PowerShell 中运行，无需管理员权限',
  macos: '在终端（Terminal）中运行',
  linux: '在终端中运行；Android 用户请先安装 Termux，脚本已自动适配',
}

const currentCommand = computed(() => (selected.value ? commands[selected.value] : ''))
const currentShellNote = computed(() => (selected.value ? shellNote[selected.value] : ''))
</script>

<template>
  <section id="install" class="border-t border-default bg-elevated/30 py-24">
    <UContainer>
      <div class="mx-auto max-w-2xl text-center">
        <p class="font-mono text-sm font-semibold text-primary-500">// 安装</p>
        <h2 class="mt-2 text-3xl font-bold tracking-tight md:text-4xl">一条命令，装好 NyaTMC</h2>
        <p class="mt-3 text-muted">脚本会从 GitHub Releases 下载最新版二进制，安装到本地并自动配置 PATH 喵～</p>
      </div>

      <!-- Release 状态提示 -->
      <UAlert
        class="mx-auto mt-8 max-w-3xl"
        icon="i-lucide-hourglass"
        color="warning"
        variant="subtle"
        title="首个 Release 尚未发布"
        description="以下命令将在首个正式版本发布后立即可用；现在尝鲜请使用下方「从源码构建」。"
      />

      <!-- 平台切换 + 命令（客户端渲染，避免 SSR 水合不匹配） -->
      <div class="mx-auto mt-8 max-w-3xl">
        <ClientOnly>
          <!-- 检测提示 -->
          <Transition name="fade">
            <div v-if="auto && detected" class="mb-4 flex items-center justify-center gap-2 text-sm text-muted">
              <UIcon name="i-lucide-scan-search" class="size-4 text-primary-500" />
              <span>已检测到你的系统：<span class="font-medium text-default">{{ platformName[selected ?? 'linux'] }}</span>，已为你选中对应命令</span>
            </div>
          </Transition>

          <!-- 平台标签页 -->
          <div class="flex flex-wrap items-center justify-center gap-2" role="tablist" aria-label="选择操作系统">
            <button
              v-for="t in tabs"
              :key="t.id"
              type="button"
              role="tab"
              :aria-selected="selected === t.id"
              class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-medium transition-colors"
              :class="selected === t.id
                ? 'border-primary-500 bg-primary-500/10 text-primary-500'
                : 'border-default bg-default text-muted hover:border-accented hover:text-default'"
              @click="select(t.id)"
            >
              <UIcon :name="t.icon" class="size-4" />
              {{ t.label }}
            </button>
          </div>

          <!-- 命令块 -->
          <div class="mt-6">
            <CommandBlock :command="currentCommand" :label="selected === 'windows' ? 'powershell' : 'bash'" />
            <p class="mt-3 flex items-center justify-center gap-1.5 text-center text-xs text-dimmed">
              <UIcon name="i-lucide-info" class="size-3.5" />
              {{ currentShellNote }}
            </p>
          </div>

          <!-- 骨架屏回退：水合前展示 -->
          <template #fallback>
            <div class="flex items-center justify-center gap-2">
              <div v-for="t in tabs" :key="t.id" class="h-10 w-28 animate-pulse rounded-lg bg-elevated" />
            </div>
            <div class="mt-6 h-32 animate-pulse rounded-xl bg-elevated" />
          </template>
        </ClientOnly>
      </div>

      <!-- 脚本做的事 + go install -->
      <div class="mx-auto mt-14 grid max-w-3xl gap-6 lg:grid-cols-2">
        <div class="rounded-card border border-default bg-default p-6">
          <h3 class="flex items-center gap-2 text-base font-semibold">
            <UIcon name="i-lucide-list-checks" class="size-5 text-primary-500" />
            安装脚本做了什么
          </h3>
          <ul class="mt-4 space-y-2.5 text-sm text-muted">
            <li class="flex gap-2.5"><UIcon name="i-lucide-cpu" class="mt-0.5 size-4 shrink-0 text-primary-500" /><span>识别系统与 CPU 架构（amd64 / arm64）</span></li>
            <li class="flex gap-2.5"><UIcon name="i-lucide-tag" class="mt-0.5 size-4 shrink-0 text-primary-500" /><span>通过 GitHub API 查询最新 Release 版本</span></li>
            <li class="flex gap-2.5"><UIcon name="i-lucide-download" class="mt-0.5 size-4 shrink-0 text-primary-500" /><span>下载对应平台的二进制压缩包并解压</span></li>
            <li class="flex gap-2.5"><UIcon name="i-lucide-route" class="mt-0.5 size-4 shrink-0 text-primary-500" /><span>安装到 <span class="font-mono">~/.local/bin</span>（Windows 为 <span class="font-mono">%USERPROFILE%\.nyatmc\bin</span>）</span></li>
            <li class="flex gap-2.5"><UIcon name="i-lucide-plug" class="mt-0.5 size-4 shrink-0 text-primary-500" /><span>自动写入 PATH 环境变量，重开终端即可使用</span></li>
          </ul>
          <p class="mt-4 text-xs text-dimmed">
            脚本源码：
            <a :href="`${cfg.installShUrl}`" target="_blank" class="text-primary-500 hover:underline">install.sh</a> ·
            <a :href="`${cfg.installPs1Url}`" target="_blank" class="text-primary-500 hover:underline">install.ps1</a>
          </p>
        </div>

        <div class="flex flex-col gap-6">
          <div>
            <CommandBlock command="go install github.com/Yuzumikonami/NyaTMC@latest" label="go install" />
            <p class="mt-3 flex items-start gap-1.5 text-xs text-warning">
              <UIcon name="i-lucide-triangle-alert" class="mt-0.5 size-3.5 shrink-0" />
              go install 方式不支持自动更新，更新时请重新执行上方安装命令喵
            </p>
          </div>

          <div class="rounded-card border border-default bg-default p-6">
            <h3 class="flex items-center gap-2 text-base font-semibold">
              <UIcon name="i-lucide-package" class="size-5 text-primary-500" />
              手动下载
            </h3>
            <p class="mt-2 text-sm text-muted">从 GitHub Releases 下载对应平台的压缩包，解压后自行加入 PATH：</p>
            <div class="mt-3 flex flex-wrap gap-1.5">
              <UBadge v-for="a in cfg.assets" :key="a" color="neutral" variant="subtle" class="font-mono text-xs">{{ a }}</UBadge>
            </div>
            <UButton :to="`${cfg.releases}/latest`" target="_blank" trailing-icon="i-lucide-external-link" label="前往 Releases 页面" variant="link" color="primary" size="sm" :padded="false" class="mt-3" />
          </div>
        </div>
      </div>

      <!-- 从源码构建 -->
      <div class="mx-auto mt-14 max-w-3xl">
        <h3 class="flex items-center gap-2 text-base font-semibold">
          <UIcon name="i-lucide-hammer" class="size-5 text-primary-500" />
          从源码构建（当前推荐）
        </h3>
        <div class="mt-4 space-y-4">
          <CommandBlock command="git clone https://github.com/Yuzumikonami/NyaTMC.git" label="bash" />
          <CommandBlock command="cd NyaTMC && go build -o nyatmc . && ./nyatmc version" label="bash" />
        </div>
      </div>
    </UContainer>
  </section>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
