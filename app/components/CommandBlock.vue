<script setup lang="ts">
/**
 * 终端风格命令块：固定深色终端外观（两种主题下都保持终端质感），
 * 右上角复制按钮，支持 Clipboard API + execCommand 降级。
 */
const props = defineProps<{
  command: string
  label?: string
}>()

const copied = ref(false)
let timer: ReturnType<typeof setTimeout> | undefined

onBeforeUnmount(() => clearTimeout(timer))

async function copy() {
  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(props.command)
    } else {
      throw new Error('clipboard unavailable')
    }
  } catch {
    // 降级方案：兼容 http 等非安全上下文
    const ta = document.createElement('textarea')
    ta.value = props.command
    ta.style.position = 'fixed'
    ta.style.opacity = '0'
    document.body.appendChild(ta)
    ta.select()
    document.execCommand('copy')
    ta.remove()
  }
  copied.value = true
  clearTimeout(timer)
  timer = setTimeout(() => (copied.value = false), 2000)
}
</script>

<template>
  <div class="overflow-hidden rounded-xl border border-default bg-zinc-950 dark:bg-black/70">
    <div class="flex items-center justify-between border-b border-white/10 bg-white/5 py-1.5 pl-4 pr-2">
      <div class="flex items-center gap-1.5" aria-hidden="true">
        <span class="size-2.5 rounded-full bg-red-400/80" />
        <span class="size-2.5 rounded-full bg-yellow-400/80" />
        <span class="size-2.5 rounded-full bg-green-400/80" />
      </div>
      <span class="font-mono text-xs text-zinc-400">{{ label ?? 'terminal' }}</span>
      <UButton
        :icon="copied ? 'i-lucide-check' : 'i-lucide-copy'"
        :label="copied ? '已复制' : '复制'"
        :color="copied ? 'success' : 'neutral'"
        variant="ghost"
        size="xs"
        class="text-zinc-300"
        :aria-label="copied ? '已复制到剪贴板' : '复制命令'"
        @click="copy"
      />
    </div>
    <div class="overflow-x-auto p-4">
      <code class="whitespace-pre font-mono text-sm text-zinc-100">
        <span class="select-none text-primary-400">$ </span>{{ command }}<span class="ml-0.5 inline-block h-4 w-2 translate-y-0.5 animate-pulse bg-primary-400/80" aria-hidden="true" />
      </code>
    </div>
  </div>
</template>
