<template lang="pug">

main.p-0.m-0.mx-5.container-md.max-vw-100
	mdb-row.p-0.m-0
		mdb-col.p-0.m-0.d-flex.flex-row.list(col="12" md="6" lg="4")
			JobList.listContent(:class="[isActive ? 'w-100' : 'w-0']")
			.listButton.bg-secondary.py-4.px-2.h-25.mt-5(@click="drawerTrigger")
				i.fas.fa-bars
		mdb-col.p-0.m-0.description
			JobDescription.bg-secondary

</template>

<script lang="coffee">
import { mdbContainer, mdbRow, mdbCol } from "mdbvue"
export default {
	components: {
		mdbRow,
		mdbCol,
		mdbContainer
	}

	data: ->
		return {
			isActive: false
		}

	methods: {
		drawerTrigger: ->
			@isActive = !@isActive
			return
	}
}
</script>

<style lang="stylus">
	@import '~/assets/responsive.styl'

	.list
		transform translateX(-10px)
		position absolute
		z-index 10

		+atMedium()
			transform translateX(0)
			position relative
			z-index 0

		&Content
			+atMedium()
				width 100% !important

		&Button
			display block
			transform translateX(0)
			border-radius 0 10px 10px 0

			+atMedium()
				display none
</style>
