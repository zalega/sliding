<script lang="ts">
	import { Card, Group, Image, Text, Badge, Button } from '@svelteuidev/core';

	export let mainTitle: string;
	export let text: string;
	export let image: string;
	export let selection: number;
	export let link: string;
	function setSelection(selection: number) {

	}
</script>

<a on:click={() => setSelection(selection)} href={link}>
	<Card shadow="sm" padding="lg" class="w-[300px]">
		<Card.Section padding="lg">
			<Image src={image} height={300} alt="puzzle image" />
		</Card.Section>

		<Group position="apart" class="p-5">
			<Text weight={500}>{mainTitle}</Text>
		</Group>

		<Text size="sm" class="px-5">
			{text}
		</Text>
	</Card>
</a>
