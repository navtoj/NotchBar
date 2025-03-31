<script lang="ts">
	let innerWidth: number = $state(0);
	let innerHeight: number = $state(0);

	let input: string = $state('');
	let output: number = $state(0);

	async function oninput(event: Event) {
		event.preventDefault();
		output = input.length;
	}
</script>

<svelte:window
	bind:innerWidth
	bind:innerHeight
/>

<div class="flex h-full items-center justify-between gap-3 bg-green-100 px-3 text-xs">
	<div class="flex gap-3 bg-red-100">
		<div class="flex justify-between divide-x border">
			<p class="p-1 px-4 font-mono">Width</p>
			<p class="p-1 px-4 font-mono">{innerWidth}</p>
		</div>
		<div class="flex justify-between divide-x border">
			<p class="p-1 px-4 font-mono">Height</p>
			<p class="p-1 px-4 font-mono">{innerHeight}</p>
		</div>
	</div>
	<div class="flex gap-3 bg-blue-100">
		<div class="flex divide-x border">
			<input
				class="p-1"
				placeholder="Type here..."
				bind:value={input}
				{oninput}
				maxlength={20}
			/>
			<p class="p-1 px-4 font-mono">{output}</p>
		</div>
	</div>
</div>
