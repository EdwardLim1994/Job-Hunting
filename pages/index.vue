<template lang="pug">

main.p-0.m-0.mx-lg-5.addTop
	mdb-row.p-0.m-0
		mdb-col.p-0.m-0.d-flex.flex-row.list(col="12" md="4")
			JobList.listContent(:class="[isActive ? 'listContent--open' : 'listContent--close']")
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
			isActive: false
			
		}

	methods: {
		drawerTrigger: ->
			@isActive = !@isActive
			return

		closeList: ->
			if(client.process)
				if(window.innerWidth <= 991)
					@isActive = false
					return
	}
}
</script>

<style lang="stylus">
	@import '~/assets/responsive.styl'

	.addTop
		transform translateY(10%)

		+atMedium()
			transform translateY(13.5%)

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

			&--open
				width 100% !important

			&--close
				width 0% !important

				+atMedium()
					width 100% !important

		&Button
			display block
			transform translateX(0)
			border-radius 0 10px 10px 0

			+atMedium()
				display none
</style>
