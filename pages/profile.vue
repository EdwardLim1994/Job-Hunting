<template lang="pug">

main.mx-3.mx-md-5.mt-3.mt-md-5.p-0.m-0.profileAddTop
	mdbContainer
		h2 My Profile
		Profile-Employee-MainProfile(v-if="getIsEmployee === true")
		//-Profile-Employer-MainProfile(v-else)

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
			if localStorage.getItem('token') == null or localStorage.getItem('token') == false
				window.location.href = "/"
				return
	computed: {
		getLogin: ->
			if(process.client)
				return localStorage.getItem('token')

		getIsEmployee: ->
			if(process.client)
				return localStorage.getItem('role') == "employee"
	}

}
</script>

<style lang="stylus" scoped>
	.profileAddTop
		transform translateY(60px)
</style>
