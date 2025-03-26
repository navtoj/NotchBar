<!-- https://tauri.app/learn/window-customization/#creating-a-custom-titlebar -->
<script lang="ts">
	import Minimize from '@lucide/svelte/icons/minimize-2';
	import UnMaximize from '@lucide/svelte/icons/minimize';
	import Maximize from '@lucide/svelte/icons/maximize';
	import Close from '@lucide/svelte/icons/x';
	import { Button } from '$lib/shadcn/ui/button';
	import { getCurrentWindow } from '@tauri-apps/api/window';
	import type { UnlistenFn } from '@tauri-apps/api/event';
	import { onDestroy, onMount } from 'svelte';

	const window = getCurrentWindow();
	let isMaximized = $state(false);

	// https://github.com/tauri-apps/tauri/issues/5812#issuecomment-1804754136
	let unlisten: UnlistenFn | null = null;
	let isWaiting = $state(false);
	async function handleResize() {
		if (isWaiting) return;
		isWaiting = true;
		isMaximized = await window.isMaximized();
		isWaiting = false;
	}
	onMount(async () => {
		isMaximized = await window.isMaximized();
		unlisten = await window.onResized(handleResize);
	});
	onDestroy(() => unlisten?.());
</script>

<div class="sticky top-0 flex h-8">
	<div class="flex w-fit border-b border-r bg-background">
		<Button
			tabindex={-1}
			class="size-auto rounded-none p-2"
			size="icon"
			variant="ghost"
			aria-label="Close"
			onclick={window.close}
		>
			<Close />
		</Button>
		<Button
			tabindex={-1}
			class="size-auto rounded-none p-2"
			size="icon"
			variant="ghost"
			aria-label="Minimize"
			onclick={window.minimize}
		>
			<Minimize />
		</Button>
		<Button
			tabindex={-1}
			class="size-auto rounded-none p-2"
			size="icon"
			variant="ghost"
			aria-label="Toggle Maximize"
			onclick={window.toggleMaximize}
		>
			{#if isMaximized}
				<UnMaximize />
			{:else}
				<Maximize />
			{/if}
		</Button>
	</div>
	<div
		data-tauri-drag-region
		class="flex-1 bg-gradient-to-b from-background from-10% via-background/90 via-50%"
	></div>
</div>
