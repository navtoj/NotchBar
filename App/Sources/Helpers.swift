@inline(__always)
func DEBUG(_ block: () -> Void) {
	#if DEBUG
		block()
	#endif
}
