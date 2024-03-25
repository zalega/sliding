<script>
	import SelectionComponent from '$lib/components/SelectionComponent.svelte';
</script>

<h1 class="text-3xl font-bold underline">Hello world!</h1>

<div class="flex gap-5 justify-center">
	<SelectionComponent
		mainTitle="3 x 3 Puzzle"
		text="Zweite Auswahl"
		image="src/lib/images/first.png"
		selection={1}
		link="/main?selection=1"
	/>
	<SelectionComponent
		mainTitle="4 x 4 Puzzle"
		text="Zweite Auswahl"
		image="src/lib/images/second.png"
		selection={2}
		link="/main?selection=2"
	/>

	<SelectionComponent
		mainTitle="5 x 5 Puzzle"
		text="Zweite Auswahl"
		image="src/lib/images/third.png"
		selection={3}
		link="/main?selection=3"
	/>
</div>

<style lang="postcss">
	:global(html) {
		background-color: theme(colors.gray.100);
	}
</style>
