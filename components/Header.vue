<template lang="pug">
mdb-navbar.row.p-0.m-0.px-1.px-md-5(expand="large" dark color="blue" position="top")
	span.col-4.p-0.m-0
		NuxtLink(to="/")
			h1.text-white.font-weight-bold Job Hunting Site
	mdb-navbar-brand.col-4.p-0.m-0(:class="screenWidth", href="#")
		img.logo(src="titleImage.jpeg")
	mdb-navbar-toggler.col-4.p-0.m-0
		mdb-navbar-nav(v-if="isLogin" right)
			mdb-nav-item(to="/profile") My Profile
			mdb-nav-item(@click="logout") Logout
		mdb-navbar-nav(v-else right)
			mdb-nav-item(@click="login") Login/Register
</template>

<script lang="coffee">
import { mdbDropdown, mdbDropdownToggle, mdbDropdownMenu, mdbDropdownItem, mdbContainer, mdbNavbar, mdbNavbarBrand, mdbNavbarToggler, mdbNavbarNav, mdbNavItem } from 'mdbvue'
export default {
	name: 'Header',
	components: {
		mdbNavbar,
		mdbNavbarBrand,
		mdbNavbarToggler,
		mdbNavbarNav,
		mdbNavItem,
		mdbContainer,
		mdbDropdown,
		mdbDropdownToggle,
		mdbDropdownMenu,
		mdbDropdownItem
	}

	data: ->
		return {
			isLogin: false
			isEmployee: false
		}


	methods: {
		logout: ->
			if(process.client)
				response = await @.$axios.post(process.env.BASE_URL + 'Users/Logout.php', {
					id: localStorage.getItem("id")
				})

				callback = response.data

				switch callback.status
					when "success"
						localStorage.removeItem("role")
						localStorage.removeItem("token")
						localStorage.removeItem("id")
						window.location.reload()
					when "failed"
						@.$emit('toast', {header: 'Error', message: callback.message})
					# when "error"

		login: ->
			
			@.$emit('showModal', true)
	}

	fetch: ->
		token = localStorage.getItem('token')
		id = localStorage.getItem('id')

		response = await @.$axios.post(process.env.BASE_URL + 'Users/Status.php', {
			id: id,
			token: token
		})
		callback = response.data
		switch callback.status
			when "success"
				if(process.client)
					@isLogin = true
					@isEmployee = if localStorage.getItem('role') == "employee" then localStorage.getItem('role') else callback.data.role
			when "failed"
				if(process.client)
					@.$emit('toast', {header: 'Failed', message: callback.message})
					@isLogin = false
			when "error"
				@.$emit('toast', {header: 'Error', message: callback.message})
				@isLogin = false

		return

	computed: {
		screenWidth: ->
			if(process.client)
				if(window.innerWidth > 991)
					return "text-center"
				else
					return ""

	}

	fetchOnServer: false
}
</script>

<style lang="stylus" scoped>
	@import '~/assets/responsive.styl'

	h1
		font-size 1rem

		+atMedium()
			font-size 2rem

	.logo
		width 40%

		+atSmall()
			width 30%

		+atMedium()
			width 20%
</style>
