<template lang="pug">
div
	Header(@showModal="handleShowModal")
	Nuxt
	Footer.footer.position-absolute.w-100
	Modals-LoginRegisterModal(:modal="showModal", @closeModal="getIsCloseModal"  @toast="onToast")
	a(@click="closeToast")
		Toast.toastZPosition(
			v-if="isToastActive" 
			:isSuccess="isSuccess", 
			:toastHeader="toastHeader", 
			:toastMessage="toastMessage"
		)

</template>

<script lang="coffee">
export default {
	data: ->
		return{
			showModal: false
			isToastActive: false
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
			@isToastActive = false
			return

		onToast: (value) ->
			@isSuccess = value.isSuccess
			@toastHeader = value.header
			@toastMessage = value.message
			@isToastActive = true
	}

}
</script>

<style lang="stylus">
	@import '~/assets/responsive.styl'

	.toastZPosition
		z-index 1060

	.footer
		z-index 10

		+atMedium()
			z-index 0
</style>