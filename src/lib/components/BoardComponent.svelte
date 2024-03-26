<script lang="ts">
	import { Loader, Image, Group, Button, Overlay } from '@svelteuidev/core';
	import { flipboard } from '@svelteuidev/motion';

	export let style: string;
	export let puzzle;
	export let puzzleImagePieces;
	export let rows;
	export let cols;
	export let intitialLoad: boolean;
	export let isSolved: boolean;
	export let isLoading: boolean;
	export let moveTile: (row: number, col: number) => void;
	export let shuffle: () => void;
	export let reloadPage: () => void;
</script>

<div class={style}>
	{#each $puzzle as row, i}
		{#each row as tile, j}
			<button
				on:click={() => moveTile(i, j)}
				disabled={intitialLoad}
				class="w-300 h-300 bg-gray-200 border flex justify-center items-center cursor-pointer text-lg"
			>
				{#if isLoading}
					<Loader />
				{:else if $puzzle[i][j] === $rows * $cols}
					<div class="text-lg"></div>
				{:else}
					<Image src={$puzzleImagePieces[tile - 1]} alt={`puzzle piece ${tile}`} />
				{/if}
			</button>
		{/each}
	{/each}
</div>
<Group position="center">
	<div class="mt-10">
		{#if intitialLoad}
			<Button
				on:click={shuffle}
				variant="gradient"
				gradient={{ from: 'teal', to: 'yellow', deg: 46 }}
				radius="xl"
				size="lg"
			>
				Shuffle
			</Button>
		{:else}
			<Button
				on:click={reloadPage}
				variant="gradient"
				gradient={{ from: 'teal', to: 'yellow', deg: 46 }}
				radius="xl"
				size="lg"
			>
				Restart
			</Button>
		{/if}
	</div>
</Group>

<div>
	{#if isSolved}
		<Overlay
			opacity={0.9}
			zIndex={5}
			class="flex align-middle justify-center"
			center
			gradient={`linear-gradient(105deg, black 20%, #312f2f 50%, $gray400 100%)`}
		>
			<Group class="flex flex-col justify-center">
				<p in:flipboard={{ duration: 800 }} class="text-green-500 mt-2 text-3xl">Puzzle Solved!</p>
				<div class="flex gap-1">

				<Button
					on:click={reloadPage}
					variant="gradient"
					gradient={{ from: 'teal', to: 'yellow', deg: 46 }}
					radius="xl"
					size="lg"
					class="w-32"
				>
					Restart
				</Button>
				<Button
					on:click={() => {
						window.location.href = '/';
					}}
					variant="gradient"
					gradient={{ from: 'teal', to: 'yellow', deg: 46 }}
					radius="xl"
					size="lg"
					class="w-32"
				>
					Other Puzzle
				</Button>
				</div>
			</Group>
		</Overlay>
	{/if}
</div>
