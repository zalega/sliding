<script lang="ts">
	import PuzzleComponent from '$lib/components/PuzzleComponent.svelte';
  import { page } from '$app/stores'
    const selection = Number($page.url.searchParams.get('selection')) || 1;
</script>

<div class="flex justify-center mt-10">
	<!-- Other content of your main page -->
	<PuzzleComponent selection={selection}/>
</div>
