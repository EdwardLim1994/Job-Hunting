<template lang="pug">
div
	Header(@showModal="handleShowModal")
	Nuxt
	Footer.footer.position-absolute.w-100
	Modals-LoginRegisterModal(:modal="showModal", @closeModal="getIsCloseModal")
	a(@click="closeToast")
		Toast(v-if="isToastActive" :isSuccess="isSuccess", :toastHeader="toastHeader", :toastMessage="toastMessage")

</template>

<script lang="coffee">
export default {
	data: ->
		return{
			showModal: false
			isToastActive: true
			isSuccess: true
			toastHeader: 'Success'
			toastMessage: 'This is a success toast'
		}
	methods: {
		handleShowModal: ->
			@showModal = !@showModal
			return

		getIsCloseModal: ->
			@showModal = false
			return

		closeToast: ->
			console.log("Clicked")
			@isToastActive = false
			return
	}
}
</script>

<style lang="stylus">
	@import '~/assets/responsive.styl'

	.footer
		z-index 10

		+atMedium()
			z-index 0
</style>