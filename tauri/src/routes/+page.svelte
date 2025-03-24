<script lang="ts">
	import { invoke } from '@tauri-apps/api/core';

	let { data } = $props();
	let input: string = $state('');
	let output: number = $state(0);

	async function oninput(event: Event) {
		event.preventDefault();
		output = data.tauri ? await invoke('svelte', { input }) : input.length;
	}
</script>

<main class="grid h-dvh place-content-center">
	{#if !data.tauri}
		<p
			class="fixed bottom-0 right-0 bg-destructive p-1 uppercase leading-none text-destructive-foreground"
		>
			local
		</p>
	{/if}
	<div class="flex divide-x border">
		<input
			class="p-2"
			placeholder="Type here..."
			bind:value={input}
			{oninput}
			maxlength="20"
		/>
		<p class="p-2 px-4 font-mono">{output}</p>
	</div>
</main>
