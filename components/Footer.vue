<template lang="pug">
mdb-footer.p-0.m-0(color="blue")
	.text-left.d-flex.justify-content-center
		mdb-row.p-0.m-0.w-50.text-center
			mdb-col.p-0.m-0.py-2
				a.hoverable
					i.fab.fa-whatsapp.fa-2x
			mdb-col.p-0.m-0.py-2
				a.hoverable
					i.fab.fa-facebook.fa-2x
			mdb-col.p-0.m-0.py-2
				a.hoverable
					i.fab.fa-twitter.fa-2x
			mdb-col.p-0.m-0.py-2
				a.hoverable
					i.fab.fa-instagram.fa-2x
	.footer-copyright.text-center
		mdb-container.py-1(fluid) NIGHTCAT DIGITAL SOLUTIONS © 2013 - {{getCurrentYear}}. ALL RIGHTS RESERVED
</template>

<script lang="coffee">
import { mdbFooter, mdbContainer, mdbRow, mdbCol } from 'mdbvue'
export default {
	name: 'Footer',
	components: {
		mdbFooter,
		mdbContainer,
		mdbRow,
		mdbCol
	}
	computed: {
		getCurrentYear: ->
			date = new Date()
			return date.getFullYear()
	}
}
</script>

<style lang="stylus" scoped>
	footer
		margin-top 0 !important
</style>
