<template lang="pug">
mdbModal(:show="modal", @close="closeModal")

		mdbModalHeader
			mdbModalTitle Update Job
		mdbModalBody
			mdbTabs(
				:active="0"
				default
				justify
				:links="[{text: 'Update', slot:'update'}, {text: 'Delete', slot:'delete'}]"
				:transition-duration="0.5"
				transition-style="linear"
			)
				template(:slot="'update'")
					form.mt-3
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
				template(:slot="'delete'")
					form.mt-3
						p You are about to delete this job. Are you sure?
						mdbModalFooter
							button.btn.btn-primary.w-100.mx-auto Delete



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
