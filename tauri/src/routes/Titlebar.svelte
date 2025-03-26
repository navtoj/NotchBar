<!-- https://tauri.app/learn/window-customization/#creating-a-custom-titlebar -->
<script lang="ts">
	import { Button } from '$lib/shadcn/ui/button';
	import Maximize from '@lucide/svelte/icons/maximize';
	import Minus from '@lucide/svelte/icons/minus';
	import Close from '@lucide/svelte/icons/x';
	import { getCurrentWindow } from '@tauri-apps/api/window';

	const window = getCurrentWindow();
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
			<Minus />
		</Button>
		<Button
			tabindex={-1}
			class="size-auto rounded-none p-2"
			size="icon"
			variant="ghost"
			aria-label="Toggle Maximize"
			onclick={window.toggleMaximize}
		>
			<Maximize />
		</Button>
	</div>
	<div
		data-tauri-drag-region
		class="flex-1 bg-gradient-to-b from-background from-10% via-background/90 via-50%"
	></div>
</div>
