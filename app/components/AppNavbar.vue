<script setup lang="ts">
const cfg = useAppConfig().nyatmc
const colorMode = useColorMode()

const links = [
  { label: '特性', to: '#features' },
  { label: '安装', to: '#install' },
]

function toggleColorMode(e: Event) {
  e.preventDefault()
  colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
}
</script>

<template>
  <header class="sticky top-0 z-50 border-b border-default bg-default/80 backdrop-blur">
    <UContainer class="flex h-16 items-center justify-between gap-3">
      <a href="https://github.com/Yuzumikonami/nyatmc" class="flex items-center gap-2 text-lg font-bold">
        <span class="text-2xl" aria-hidden="true">🐾</span>
        <span class="font-mono">NyaTMC</span>
        <UBadge color="warning" variant="subtle" size="sm">开发中</UBadge>
      </a>

      <nav class="hidden items-center gap-1 md:flex" aria-label="页面导航">
        <a
          v-for="l in links"
          :key="l.to"
          :href="l.to"
          class="rounded-md px-3 py-1.5 text-sm font-medium text-muted transition-colors hover:bg-elevated hover:text-default"
        >{{ l.label }}</a>
      </nav>

      <div class="flex items-center gap-1.5">
        <ClientOnly>
          <UButton
            :icon="colorMode.value === 'dark' ? 'i-lucide-moon' : 'i-lucide-sun'"
            variant="ghost"
            color="neutral"
            aria-label="切换明暗主题"
            @click="toggleColorMode"
          />
          <template #fallback>
            <div class="size-8" />
          </template>
        </ClientOnly>
        <UButton
          :to="cfg.github"
          target="_blank"
          icon="i-simple-icons-github"
          label="GitHub"
          variant="outline"
          color="neutral"
        />
      </div>
    </UContainer>
  </header>
</template>
