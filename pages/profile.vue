<template lang="pug">

	main.mx-5.mt-3.mt-md-5.p-0.m-0
		h2 My Profile
		Profile-Employee-MainProfile(v-if="getIsEmployee === 'true'")
		Profile-Employer-MainProfile(v-else)

</template>

<script lang="coffee">
import { mdbContainer,mdbRow, mdbCol, mdbTabs } from "mdbvue"
export default {
	components: {
		mdbContainer,
		mdbCol,
		mdbRow,
		mdbTabs,
	}
	created: ->
		if(process.client)
			if localStorage.getItem('login') == null or localStorage.getItem('login') == false
				window.location.href = "/"
				return
	computed: {
		getLogin: ->
			if(process.client)
				return localStorage.getItem('login')

		getIsEmployee: ->
			if(process.client)
				data =  localStorage.getItem('role')
				return data
	}
}
</script>

<style lang="stylus" scoped>
	.tableHeight
		height 500px
</style>
