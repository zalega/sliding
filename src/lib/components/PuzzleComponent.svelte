<script lang="ts">
	import { Button, Overlay, Image as SvelteImage } from '@svelteuidev/core';
	import { writable, type Writable } from 'svelte/store';
	import { flipboard } from '@svelteuidev/motion';
	import { onMount } from 'svelte';

	export let selection: number;

	// Define the puzzle size
	let rows = writable(3);
	let cols = writable(3);

	let isSolved = false;
	let intitialLoad = true;

	const imageUrl = ['/first.png', '/second.png', '/third.png'];

	type PuzzleType = number[][];

	// Define the puzzle grid
	let puzzle: Writable<PuzzleType> = writable([]);

	$: {
		generatePuzzle();
	}

	$: rows.subscribe(generatePuzzle);
	$: cols.subscribe(generatePuzzle);

	function generatePuzzle() {
		let count = 1;
		const updatedPuzzle = Array.from({ length: Number($rows) }, (_, i) =>
			Array.from({ length: $cols }, (_, j) => count++)
		);
		puzzle.set(updatedPuzzle);
	}

	function shuffle() {
		// Shuffle the puzzle
		const puzzleArray = $puzzle;
		const flatPuzzle = puzzleArray.flat();
		for (let i = flatPuzzle.length - 1; i > 0; i--) {
			const j = Math.floor(Math.random() * (i + 1));
			[flatPuzzle[i], flatPuzzle[j]] = [flatPuzzle[j], flatPuzzle[i]];
		}
		const shuffledPuzzle = Array.from({ length: $rows }, (_, i) =>
			flatPuzzle.slice(i * $cols, (i + 1) * $cols)
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
				if ($puzzle[i][j] === $rows * $cols) {
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
		let count = 1;

		const solvedPuzzle = Array.from({ length: Number($rows) }, (_, i) =>
			Array.from({ length: $cols }, (_, j) => count++)
		); // Assuming generatePuzzle() generates the solved puzzle

		// Compare the current puzzle with the solved puzzle
		for (let i = 0; i < $rows; i++) {
			for (let j = 0; j < $cols; j++) {
				if ($puzzle[i][j] !== solvedPuzzle[i][j]) {
					return false;
				}
			}
		}

		return true; // Puzzle is solved
	}

	let puzzleImagePieces: Writable<string[]> = writable([]);

	onMount(async () => {
		if (selection === 1) {
			rows.set(3);
			cols.set(3);
		} else if (selection === 2) {
			rows.set(4);
			cols.set(4);
		} else if (selection === 3) {
			rows.set(5);
			cols.set(5);
		}
		const image = new Image();
        image.src = `/src/lib/images${imageUrl[selection - 1]}`;

        await new Promise<void>((resolve, reject) => {
            image.onload = () => {
                const pieceWidth = image.width / $cols;
                const pieceHeight = image.height / $rows;

                const updatedPuzzleImagePieces = [];

                for (let j = 0; j < $rows; j++) {
                    for (let i = 0; i < $cols; i++) {
                        const canvas = document.createElement('canvas');
                        canvas.width = pieceWidth;
                        canvas.height = pieceHeight;
                        const context = canvas.getContext('2d');
                        if (context) {
                            context.drawImage(
                                image,
                                i * pieceWidth,
                                j * pieceHeight,
                                pieceWidth,
                                pieceHeight,
                                0,
                                0,
                                canvas.width,
                                canvas.height
                            );
                            updatedPuzzleImagePieces.push(canvas.toDataURL());
                        }
                    }
                }
				puzzleImagePieces.set(updatedPuzzleImagePieces); // Update the store with new puzzle pieces
				resolve();
			};
			image.onerror = (error) => {
				reject(error);
			};
		});
		
	});

	$: {
		puzzleImagePieces;
	}
</script>

<div>
	{#if selection === 1}
		<div class="w-[800px] h-[800px] grid grid-cols-3 gap-1">
			{#each $puzzle as row, i}
				{#each row as tile, j}
					<button
						on:click={() => moveTile(i, j)}
						disabled={intitialLoad}
						class="w-300 h-300 bg-gray-200 border flex justify-center items-center cursor-pointer text-lg"
					>
						{#if $puzzle[i][j] === $rows * $cols}
							<div class="text-lg"></div>
						{:else}
							<SvelteImage src={$puzzleImagePieces[tile - 1]} alt={`puzzle piece ${tile}`} />
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
	{:else if selection === 2}
		<div class="w-[800px] h-[800px] grid grid-cols-4 gap-1">
			{#each $puzzle as row, i}
				{#each row as tile, j}
					<button
						on:click={() => moveTile(i, j)}
						disabled={intitialLoad}
						class="w-300 h-300 bg-gray-200 flex justify-center items-center cursor-pointer text-lg"
					>
						{#if $puzzle[i][j] === $rows * $cols}
							<div class="text-lg"></div>
						{:else}
							<SvelteImage src={$puzzleImagePieces[tile - 1]} alt={`puzzle piece ${tile}`} />
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
	{:else if selection === 3}
		<div class="w-[800px] h-[800px] grid grid-cols-5 gap-1">
			{#each $puzzle as row, i}
				{#each row as tile, j}
					<button
						on:click={() => moveTile(i, j)}
						disabled={intitialLoad}
						class="w-100 h-100 bg-gray-200 border flex justify-center items-center cursor-pointer text-lg"
					>
						{#if $puzzle[i][j] === $rows * $cols}
							<div class="text-lg"></div>
						{:else}
							<SvelteImage src={$puzzleImagePieces[tile - 1]} alt={`puzzle piece ${tile}`} />
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
	{/if}
</div>
