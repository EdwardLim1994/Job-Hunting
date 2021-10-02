<template lang="pug">
mdbModal(:show="modal", @close="closeModal")
	mdbModalHeader.bg-primary
		mdb-modal-title.text-white Login/Register
	mdbModalBody
		mdbTabs(
			:active="0"
			default
			justify
			:links="[{text: 'Login', slot:'login'}, {text: 'Register', slot:'register'}]"
			:transition-duration="0.3"
			transition-style="ease-in-out"
		)
			template(:slot="'login'")
				mdbContainer
					Modals-Forms-LoginForm.w-100.px-3.pt-4(@toast="onToast")
			template(:slot="'register'")
				mdbContainer
					Modals-Forms-RegisterForm.w-100.px-3.pt-4(@toast="onToast")

</template>

<script lang="coffee">
import { mdbModal, mdbContainer, mdbModalHeader, mdbModalTitle, mdbModalBody, mdbModalFooter, mdbBtn, mdbTabs } from 'mdbvue'

export default {
	components: {
		mdbContainer,
		mdbModal,
		mdbModalHeader,
		mdbModalTitle,
		mdbModalBody,
		mdbModalFooter,
		mdbBtn,
		mdbTabs
	},
	props: ['modal'],
	data: ->
		return {
			isOpen: false
		}
	methods: {
		closeModal: ->
			@.$emit('closeModal', false)

		onToast: (value) ->
			@.$emit("toast", value)
	}

}
</script>

<style lang="stylus" scoped></style>
