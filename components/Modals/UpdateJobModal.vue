<template lang="pug">
mdbModal(:show="modal", @close="closeModal")
	form
		mdbModalHeader
			mdbModalTitle Update Job
		mdbModalBody

			.form-group
				label(for="position") Job Position
				input#position.form-control(type="text")

			.form-group
				label(for="salary") Basic Salary (RM)
				input#salary.form-control(type="number", min="1", step="1")

			.form-group
				label(for="description") Description
				textarea#description.form-control

			.form-group
				label(for="requirement") Requirement
				textarea#requirement.form-control
		mdbModalFooter
			button.btn.btn-primary.w-100.mx-auto Update



</template>

<script lang="coffee">
import { mdbModal, mdbModalHeader, mdbModalTitle, mdbModalBody, mdbModalFooter, mdbBtn, mdbTabs } from 'mdbvue'
export default {
	components: {
		mdbModal,
		mdbModalHeader,
		mdbModalTitle,
		mdbModalBody,
		mdbModalFooter,
		mdbBtn,
		mdbTabs
	},
	props: ["modal"]
	methods: {
		closeModal: ->
			@.$emit('closeModal', false)
	}
}
</script>
