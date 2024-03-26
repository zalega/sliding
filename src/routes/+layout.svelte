<script>
	import '../app.css';
	import { SvelteUIProvider } from '@svelteuidev/core';
</script>

<SvelteUIProvider themeObserver="dark">
	<slot />
</SvelteUIProvider>

<style lang="postcss">
	:global(html) {
		background-color: theme(colors.gray.100);
	}
</style>
