<script lang="ts">
	import { Button, Loader, Overlay, Image as SvelteImage, Group } from '@svelteuidev/core';
	import { writable, type Writable } from 'svelte/store';
	import { flipboard } from '@svelteuidev/motion';
	import { onMount } from 'svelte';
	import BoardComponent from './BoardComponent.svelte';

	export let selection: number;

	// Define the puzzle size
	let rows = writable(3);
	let cols = writable(3);

	let isSolved = false;
	let intitialLoad = true;
	let isLoading = true;

	const imageUrl = ['/first.jpg', '/second.jpg', '/third.jpg'];

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
		isLoading = false;
	});

	$: {
		puzzleImagePieces;
	}

	function reloadPage() {
		window.location.href = window.location.href;
	}
</script>

<div>
	{#if selection === 1}
		<BoardComponent
			style="w-[800px] h-[800px] grid grid-cols-3 gap-1"
			{puzzle}
			{puzzleImagePieces}
			{rows}
			{cols}
			{intitialLoad}
			{isSolved}
			{isLoading}
			{moveTile}
			{shuffle}
			{reloadPage}
		/>
	{:else if selection === 2}
		<BoardComponent
			style="w-[800px] h-[800px] grid grid-cols-4 gap-1"
			{puzzle}
			{puzzleImagePieces}
			{rows}
			{cols}
			{intitialLoad}
			{isSolved}
			{isLoading}
			{moveTile}
			{shuffle}
			{reloadPage}
		/>
	{:else if selection === 3}
		<BoardComponent
			style="w-[800px] h-[800px] grid grid-cols-5 gap-1"
			{puzzle}
			{puzzleImagePieces}
			{rows}
			{cols}
			{intitialLoad}
			{isSolved}
			{isLoading}
			{moveTile}
			{shuffle}
			{reloadPage}
		/>
	{/if}
</div>
