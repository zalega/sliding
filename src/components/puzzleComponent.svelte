<script lang="ts">
	import { onMount } from 'svelte';
	import { writable } from 'svelte/store';

	// Define the puzzle size
	const rows = 3;
	const cols = 3;

	// Define the puzzle grid
	const puzzle = writable(generatePuzzle());

	function generatePuzzle() {
		// Generate a solved puzzle
		let count = 1;
		return Array.from({ length: rows }, (_, i) => Array.from({ length: cols }, (_, j) => count++));
	}

	function shuffle() {
		// Shuffle the puzzle
		const puzzleArray = $puzzle;
		const flatPuzzle = puzzleArray.flat();
		for (let i = flatPuzzle.length - 1; i > 0; i--) {
			const j = Math.floor(Math.random() * (i + 1));
			[flatPuzzle[i], flatPuzzle[j]] = [flatPuzzle[j], flatPuzzle[i]];
		}
		const shuffledPuzzle = Array.from({ length: rows }, (_, i) =>
			flatPuzzle.slice(i * cols, (i + 1) * cols)
		);
		puzzle.set(shuffledPuzzle);
	}

	function moveTile(row: number, col: number) {
		// Move the tile if possible
		// Your move logic here
	}

	onMount(() => {
		// Initial shuffle on component mount
		shuffle();
	});

	export const PuzzleComponent = {
		puzzle,
		shuffle,
		moveTile
	};
</script>

<div class="w-[200px] h-[200px] grid grid-cols-3 gap-2">
	{#each $puzzle as row, i}
		{#each row as tile, j}
			<button
				on:click={() => moveTile(i, j)}
				class="w-10 h-10 bg-gray-200 border border-gray-400 flex justify-center items-center cursor-pointer text-lg p-4"
			>
				{#if i === rows - 1 && j === cols - 1}
					<div class="text-lg"></div>
				{:else}
					<div class="text-lg">{tile}</div>
				{/if}
			</button>
		{/each}
	{/each}
</div>

<style>
	/* Your styling here */
</style>
