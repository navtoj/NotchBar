<script lang="ts">
	import { ModeWatcher } from 'mode-watcher';
	import '../app.css';
	import Titlebar from './Titlebar.svelte';

	let { children, data } = $props();
</script>

<ModeWatcher themeColors={{ dark: 'black', light: 'white' }} />

<main class="flex h-dvh select-none flex-col overflow-auto overscroll-none">
	{#if !data.tauri}
		<div class="grid flex-1 place-content-center">
			<p class=" font-mono text-xl uppercase">
				<span class="text-destructive">error</span>
				<span class="dark:text-muted-foreground">backend not found</span>
			</p>
		</div>
	{:else}
		<Titlebar />
		<div class="flex-1">
			{@render children()}
		</div>
	{/if}
</main>
