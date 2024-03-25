<script>
	import '../app.css';
	import { SvelteUIProvider } from '@svelteuidev/core';
</script>

<style lang="postcss">
	:global(html) {
		background-color: theme(colors.gray.100);
	}
</style>

<SvelteUIProvider themeObserver="dark">
	<slot />
</SvelteUIProvider>
