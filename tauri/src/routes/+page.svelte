<script lang="ts">
	let input: string = $state('');
	let output: number = $state(0);

	async function oninput(event: Event) {
		event.preventDefault();
		output = input.length;
	}
</script>

<div class="grid h-full place-content-center">
	<div class="flex divide-x border">
		<input
			class="p-2"
			placeholder="Type here..."
			bind:value={input}
			{oninput}
			maxlength={20}
		/>
		<p class="p-2 px-4 font-mono">{output}</p>
	</div>
</div>
