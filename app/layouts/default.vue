<template>
  <div class="min-h-screen flex flex-col bg-default text-default">
    <AppNavbar />
    <main class="flex-1">
      <slot />
    </main>
    <AppFooter />
  </div>
</template>
