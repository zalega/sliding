<script>
	import SelectionComponent from '$lib/components/SelectionComponent.svelte';
	import { flipboard } from '@svelteuidev/motion';
	import { onMount } from 'svelte';

	let visible = false;

	onMount(() => {
		// Set visible to true after a short delay to trigger the transition on page load
		setTimeout(() => {
			visible = true;
		}, 100); // Adjust the delay as needed
	});
</script>

<div class="h-[100px]">
	{#if visible}
		<p
			in:flipboard={{ duration: 1300 }}
			class="flex justify-center text-5xl font-bold underline m-10"
		>
			Willkommen zu meinem personalisiertem Sliding Puzzle!
		</p>
	{:else}
		<p class="flex justify-center text-3xl font-bold underline m-10"></p>
	{/if}
</div>

<div class="flex gap-5 justify-center h-[800px] items-center">
	<SelectionComponent
		mainTitle="3 x 3 Puzzle"
		text="Ein einfaches Slidding Puzzle. Wähle diese Auswahl, um zu beginnen."
		image="/images/first.jpg"
		selection={1}
		link="/main?selection=1"
	/>
	<SelectionComponent
		mainTitle="4 x 4 Puzzle"
		text="Eine ausgewogene Pizza. Wähle diese Auswahl, um zu beginnen."
		image="/images/second.jpg"
		selection={2}
		link="/main?selection=2"
	/>

	<SelectionComponent
		mainTitle="5 x 5 Puzzle"
		text="Das beste zum Schluss. Wähle diese Auswahl, um zu beginnen."
		image="/images/third.jpg"
		selection={3}
		link="/main?selection=3"
	/>
</div>

<style lang="postcss">
	:global(html) {
		background-color: theme(colors.gray.100);
	}
</style>
