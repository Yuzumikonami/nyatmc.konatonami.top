<script setup lang="ts">
const cfg = useAppConfig().nyatmc
const year = new Date().getFullYear()
</script>

<template>
  <footer class="border-t border-default py-10">
    <UContainer class="flex flex-col items-center gap-3 text-center">
      <p class="text-sm text-muted">
        © {{ year }}
        <a :href="cfg.authorSite" target="_blank" class="font-medium text-default hover:text-primary-500 transition-colors">Yuzumikonami（柚见小南）</a>
      </p>

      <nav class="flex items-center gap-5 text-sm text-muted" aria-label="页脚链接">
        <a :href="cfg.github" target="_blank" class="hover:text-default transition-colors">GitHub</a>
        <a :href="cfg.releases" target="_blank" class="hover:text-default transition-colors">Releases</a>
        <a :href="`${cfg.github}/blob/main/LICENSE`" target="_blank" class="hover:text-default transition-colors">GPL-3.0</a>
      </nav>

      <p class="text-xs text-dimmed">用 🐾 和 ❤️ 搭建喵w ~ 🐾</p>
    </UContainer>
  </footer>
</template>
