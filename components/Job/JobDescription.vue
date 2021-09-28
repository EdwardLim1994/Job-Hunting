<template lang="pug">
mdb-container
	div
		.row.p-4
			.col-12.col-md-4.d-flex.align-items-center.justify-content-center
				img.w-50(src="placeholder-images-image_large.png")
			.col
				h2.h2.p-0.m-0 Test Job 1
				p.p-0.m-0.company
					small.text-muted ABC Company
				.row.pt-3.p-0.m-0(v-if="getLogin")
					.col-6.p-0.m-0
						table
							tr
								td
									strong Experience
									br
									| 2 years
							tr
								td
									strong Salary 
									br
									| RM 4000
							tr
								td
									strong Posted Date 
									br
									| 21/09/2021
					.col-6.p-0.m-0
						table
							tr
								td
									strong Address
							tr
								td
									p.p-0.m-0 14, Jalan tak dapat jumpa
									p.p-0.m-0 Bandar Tak pernah wujud
									p.p-0.m-0 81402, Skudai Johor
	div
		mdb-tabs(
			:active="0",
			default,
			:links="[{text: 'Description'},{text: 'Requirement'}]",
			:content="['This is description','This is requirement']")


</template>

<script lang="coffee">
import { mdbContainer, mdbCol, mdbRow, mdbIcon, mdbTabs } from 'mdbvue'
export default {
	name: 'JobDescription'
	components: {
		mdbContainer,
		mdbCol,
		mdbRow,
		mdbIcon,
		mdbTabs
	}

	computed: {
		getLogin: ->
			if(process.client)
				return localStorage.getItem('login')
	}
}
</script>

<style lang="stylus" scoped>
	.company
		transform translateY(-8px)
</style>
