<template lang="pug">
mdbModal(size="lg",scrollable, :show="modal", @close="closeModal")
	mdbModalHeader
		mdbModalTitle Job Description
	mdbModalBody
		mdbTabs(
			:active="0"
			default
			justify
			:links="[{text: 'Detail', slot:'viewDetail'}, {text: 'Delete', slot:'delete'}]"
			:transition-duration="0.5"
			transition-style="linear"
			)
			template(:slot="'viewDetail'")
				mdbContainer
					JobDescription
			template(:slot="'delete'")
				form.mt-3
					p You are about to unsave current job. Are you sure?
					mdbModalFooter
						button.btn.btn-primary.w-50.mx-auto Delete
</template>

<script lang="coffee">
	import {  mdbModal, mdbModalHeader, mdbModalTitle, mdbModalBody, mdbModalFooter, mdbBtn, mdbTabs, mdbContainer } from "mdbvue"
	export default {
		components: {
			mdbModal,
			mdbModalHeader,
			mdbModalTitle,
			mdbModalBody,
			mdbModalFooter,
			mdbBtn,
			mdbTabs,
			mdbContainer
		}
		props: ['modal'],
		data: ->
			return {
				isOpen: false
			}
		methods: {
			closeModal: ->
				@.$emit('closeModal', false)
		}
	}
</script>
