<template lang="pug">
div
	Header
	Nuxt
	Footer.footer.position-absolute.w-100
</template>

<script lang="coffee">
export default {
    
}
</script>

<style lang="stylus">
	@import '~/assets/responsive.styl'

	.footer
		z-index 10

		+atMedium()
			z-index 0
</style>