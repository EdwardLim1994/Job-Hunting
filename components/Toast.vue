<template lang="pug">
.toastMain.rounded.fixed-top.mt-5.mr-auto.ml-auto.px-3.py-2(:class="isSuccess ? 'bg-success' : 'bg-danger'" style="width: 300px;")
	h5.border-bottom.border-white.pb-1.font-weight-bold.text-white {{toastHeader}}
	p.pb-0.mb-0.text-white {{toastMessage}}
</template>

<script lang="coffee">
	export default {
		props: ['isSuccess', 'toastHeader', 'toastMessage']
	}
</script>

<style lang="stylus" scoped>
	@import '~/assets/responsive.styl'

	.toastMain
		transform translateY(20px)

		+atMedium()
			transform translateY(50px)
</style>
