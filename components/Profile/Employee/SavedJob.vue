<template lang="pug">
div
	mdb-datatable-2.mt-4(v-model="data" scrollY hover maxHeight="400px"  @selected="getSelectedRow")
	
</template>

<script lang="coffee">
	import { mdbDatatable2 } from 'mdbvue'
	export default {
		name: 'SavedJob'
		components: {
			mdbDatatable2,
		}
		methods: {
			getSelectedRow: (e) ->
				@.$emit("showJobDetailModal")
			
		}
		data: -> 
			return {
				showModal: false
				data: {
					columns: [
						{
							label: 'ID',
							field: 'id',
							sort: true,
						},
						{
							label: 'Job Position',
							field: 'position',
							sort: true,
						},
						{
							label: 'Experience (Year)',
							field: 'experience',
							sort: true,
						},
						{
							label: 'Salary (RM)',
							field: 'salary',
							sort: true
						},
						{
							label: 'Created Date',
							field: 'createdDate',
							sort: true,
						}
					],
					rows: [
						{
							id: 1,
							position: 'Test Job 1',
							experience: 2,
							salary: 4000.00,
							createdDate: '2011/04/25'
						},
					],
				},
			}
	}
	
</script>