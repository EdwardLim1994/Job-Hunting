<template lang="pug">
div
  mdb-navbar.row.p-0.m-0.px-1.px-md-5(expand="large" dark color="blue")
    span.col-4.p-0.m-0
      h1.text-white.font-weight-bold Job Hunting Site
    mdb-navbar-brand.col-4.p-0.m-0(:class="screenWidth", href="#")
      img.logo(src="titleImage.jpeg")
    mdb-navbar-toggler.col-4.p-0.m-0
      mdb-navbar-nav(v-if="getLogin" right)
        mdb-nav-item(v-if="getIsEmployee" href="/employee") My Profile
        mdb-nav-item(v-else href="/employer") My Profile
        mdb-nav-item(@click="logout") Logout
      mdb-navbar-nav(v-else right)
        mdb-nav-item(@click="login") Login/Register
  .mt-5.pt-5.d-none
    button.btn.btn-primary(v-on:click="setEmployee") Click Me
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
    setEmployee: ->
      if(process.client)
        localStorage.setItem("test", !@.isEmployee)
        window.location.reload()
    logout: ->
      if(process.client)
        localStorage.removeItem("test")
        localStorage.removeItem("login")
        window.location.reload()

    login: ->
      if(process.client)
        localStorage.setItem("login", !@.isLogin)
        window.location.reload()
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
        return localStorage.getItem('test')
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
