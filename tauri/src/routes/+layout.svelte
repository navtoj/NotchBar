<script lang="ts">
	import { ModeWatcher } from 'mode-watcher';
	import '../app.css';

	let { children } = $props();
</script>

<ModeWatcher themeColors={{ dark: 'black', light: 'white' }} />

{@render children()}
