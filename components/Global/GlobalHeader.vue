<template lang="pug">
header
	mdb-navbar(color='blue', dark)
		mdb-navbar-brand(href="#")
			NuxtLink(to="/")
				img.icon.hoverable.rounded(src="/titleImage.jpeg")
		mdb-navbar-toggler
			mdb-navbar-nav


</template>

<script lang="coffee">
import { mdbNavbar, mdbNavbarBrand, mdbNavbarToggler, mdbNavbarNav, mdbNavItem, mdbDropdown, mdbDropdownMenu, mdbDropdownToggle, mdbInput, mdbDropdownItem } from 'mdbvue';
export default {
	components: {
			mdbNavbar,
			mdbNavbarBrand,
			mdbNavbarToggler,
			mdbNavbarNav,
			mdbNavItem,
			mdbDropdown,
			mdbDropdownMenu,
			mdbDropdownToggle,
			mdbDropdownItem,
			mdbInput
	}
}
</script>

<style lang="stylus" scoped>
	.icon
		width 20%
</style>
