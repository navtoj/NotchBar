<script lang="ts">
	import { ModeWatcher } from 'mode-watcher';
	import '../app.css';

	let { children, data } = $props();
</script>

<ModeWatcher themeColors={{ dark: 'black', light: 'white' }} />

{#if data.tauri}
	{@render children()}
{:else}
	<main class="flex h-dvh items-center justify-center bg-black">
		<p class="font-mono text-xl uppercase text-white">backend not found</p>
	</main>
{/if}
