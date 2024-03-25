<script lang="ts">
	import { Button, Overlay } from '@svelteuidev/core';
	import { writable, type Writable } from 'svelte/store';
	import { flipboard } from '@svelteuidev/motion';

	// Define the puzzle size
	const rows = 3;
	const cols = 3;

	let isSolved = false;
	let intitialLoad = true;

	// Define the puzzle grid
	const puzzle: Writable<number[][]> = writable(generatePuzzle());

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
		isSolved = false;
		intitialLoad = false;
	}

	function moveTile(row: number, col: number) {
		// Find the row and column indices of the empty space
		let emptyRowIndex = -1;
		let emptyColIndex = -1;
		$puzzle.forEach((r, i) => {
			r.forEach((_, j) => {
				if ($puzzle[i][j] === rows * cols) {
					emptyRowIndex = i;
					emptyColIndex = j;
				}
			});
		});

		// Check if the clicked tile is adjacent to the empty space
		const isAdjacent =
			(row === emptyRowIndex && Math.abs(col - emptyColIndex) === 1) ||
			(col === emptyColIndex && Math.abs(row - emptyRowIndex) === 1);

		if (isAdjacent) {
			// Swap the clicked tile with the empty space
			const updatedPuzzle = $puzzle.map((r) => [...r]); // Create a shallow copy
			const temp = updatedPuzzle[row][col];
			updatedPuzzle[row][col] = updatedPuzzle[emptyRowIndex][emptyColIndex];
			updatedPuzzle[emptyRowIndex][emptyColIndex] = temp;

			// Update the puzzle state
			puzzle.set(updatedPuzzle);
		}
		isSolved = checkIsSolved();
	}

	function checkIsSolved(): boolean {
		const solvedPuzzle = generatePuzzle(); // Assuming generatePuzzle() generates the solved puzzle

		// Compare the current puzzle with the solved puzzle
		for (let i = 0; i < rows; i++) {
			for (let j = 0; j < cols; j++) {
				if ($puzzle[i][j] !== solvedPuzzle[i][j]) {
					return false;
				}
			}
		}

		return true; // Puzzle is solved
	}
	// onMount(() => {
	// 	// Initial shuffle on component mount
	// 	shuffle();
	// });

	export const PuzzleComponent = {
		puzzle,
		shuffle,
		moveTile
	};
</script>

<div>
	<div class="w-[400px] h-[400px] grid grid-cols-3 gap-2">
		{#each $puzzle as row, i}
			{#each row as tile, j}
				<button
					on:click={() => moveTile(i, j)}
					disabled={intitialLoad}
					class="w-300 h-300 bg-gray-200 border border-gray-400 flex justify-center items-center cursor-pointer text-lg p-4"
				>
					{#if $puzzle[i][j] === rows * cols}
						<div class="text-lg"></div>
					{:else}
						<div class="text-lg">{tile}</div>
					{/if}
				</button>
			{/each}
		{/each}
	</div>

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
		{/if}
	</div>
	<div>
		{#if isSolved}
			<Overlay opacity={0.6} color="#000" zIndex={5} center>
				<p in:flipboard={{ duration: 400 }} class="text-green-500 mt-2">Puzzle Solved!</p>
			</Overlay>
		{/if}
	</div>
</div>

<style>
	/* Your styling here */
</style>
