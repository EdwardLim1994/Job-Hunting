<template lang="pug">
  mdb-navbar.row.p-0.m-0.px-1.px-md-5(expand="large" dark color="blue" position="top")
    span.col-4.p-0.m-0
      NuxtLink(to="/")
        h1.text-white.font-weight-bold Job Hunting Site
    mdb-navbar-brand.col-4.p-0.m-0(:class="screenWidth", href="#")
      img.logo(src="titleImage.jpeg")
    mdb-navbar-toggler.col-4.p-0.m-0
      mdb-navbar-nav(v-if="getLogin" right)
        mdb-nav-item(v-if="getIsEmployee" to="/profile") My Profile
        mdb-nav-item(v-else to="/profile") My Profile
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
        localStorage.removeItem("role")
        localStorage.removeItem("login")
        window.location.href = "/"
    login: ->
      @.$emit('showModal', true)
  }

  computed: {
    screenWidth: ->
      if(process.client)
        if(window.innerWidth > 991)
          return "text-center"
        else
          return ""

    getLogin: ->
      if(process.client)
        return localStorage.getItem('login')

    getIsEmployee: ->
      if(process.client)
        return localStorage.getItem('role')
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
