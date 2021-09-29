<template lang="pug">
div
	Header(@showModal="handleShowModal")
	Nuxt
	Footer.footer.position-absolute.w-100
	Modals-LoginRegisterModal(:modal="showModal", @closeModal="getIsCloseModal")
</template>

<script lang="coffee">
export default {
	data: ->
		return{
			showModal: false
		}
	methods: {
		handleShowModal: ->
			@showModal = !@showModal
			return

		getIsCloseModal: ->
			@showModal = false
			return
	}
}
</script>

<style lang="stylus">
	@import '~/assets/responsive.styl'

	.addTop
		transform translateY(13%)

	.footer
		z-index 10

		+atMedium()
			z-index 0
</style>