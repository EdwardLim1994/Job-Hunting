<template lang="pug">
mdb-container
	div
		.row.p-4
			.col-4.d-flex.align-items-center
				img.img-fluid(src="placeholder-images-image_large.png")
			.col
				h2.h2.p-0.m-0 Test Job 1
				p.p-0.m-0.company
					small.text-muted ABC Company
				.row.pt-3
					.col-6
						table
							tr
								td
									strong Experience :
								td 2 years
							tr
								td
									strong Salary :
								td RM 4000
							tr
								td
									strong Posted Date :
								td 21/09/2021
					.col-6
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
}
</script>

<style lang="stylus" scoped>
	.company
		transform translateY(-8px)
</style>
