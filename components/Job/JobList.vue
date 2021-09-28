<template lang="pug">
div.listContainer
	.listContent
		JobOptions.m-0.hoverable.option
		JobOptions.m-0.hoverable.option
		JobOptions.m-0.hoverable.option
		JobOptions.m-0.hoverable.option
		JobOptions.m-0.hoverable.option
		JobOptions.m-0.hoverable.option
		JobOptions.m-0.hoverable.option

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
	@import '~/assets/responsive.styl'

	.list
		&Container
			overflow auto

		&Content
			max-height 80vh
			overflow auto
			position relative

	.option
		margin-bottom 2px !important

	.hoverable:hover
		background-color grey !important
</style>


