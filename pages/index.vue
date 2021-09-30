<template lang="pug">

main.p-0.m-0.mx-lg-5.addTop
	mdb-row.p-0.m-0
		mdb-col.p-0.m-0.d-flex.flex-row.list(col="12" md="4")
			Job-SearchJobBar.mt-2(:class="[isListActive ? 'w-100' : 'hideInMobile']")
			JobList.listContentMaster(:class="[isListActive ? 'listContentMaster--open' : 'listContentMaster--close']")
			.listButton.py-4.px-2.h-25.mt-5(@click="drawerTrigger")
				i.fas.fa-bars
		mdb-col.p-0.m-0.description
			JobDescription
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
			isListActive: false
			isInDesktopView: true
		}


	methods: {
		drawerTrigger: ->
			@isListActive = !@isListActive
			return

		closeList: ->
			if(client.process)
				if(window.innerWidth <= 991)
					@isListActive = false
					return
				else
					@isListActive = true
	}
}
</script>

<style lang="stylus" scoped>
	@import '~/assets/responsive.styl'

	.addTop
		transform translateY(10%)

		+atMedium()
			transform translateY(13.5%)

	.hideInMobile
		display none

		+atMedium()
			display flex
			width 100%

	.list
		// transform translateX(-10px)
		position absolute

		+atMedium()
			transform translateX(0)
			position relative
			z-index 0

		&ContentMaster
			+atMedium()
				width 100% !important

			&--open
				width 100% !important
				z-index 10

			&--close
				width 0% !important
				z-index 0

				+atMedium()
					width 100% !important

		&Button
			display block
			transform translateX(0)
			border-radius 0 10px 10px 0
			z-index 10

			+atMedium()
				display none
</style>
