<template lang="pug">
	mdb-row.py-3.px-2.pl-3.bg-white
		mdb-col.p-0.m-0.pl-2.d-flex.align-items-center(col="4")
			img.w-75(src="placeholder-images-image_large.png")
		mdb-col.p-0.m-0(col="8")
			h2.h2.p-0.m-0 Test
			p.p-0.m-0.company
				small.text-muted ABC Company
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
</template>

<script lang="coffee">
import { mdbRow, mdbCol } from "mdbvue"
export default {
	components: {
		mdbRow,
		mdbCol
	}
}
</script>

<style lang="stylus" scoped>
	.company
		transform translateY(-8px)
</style>
