<template lang="pug">
form(@submit.prevent)
	.form-group
		label(for="registerName") Your Name
		input#registerName.form-control(type="text")
	.form-group
		label(for="registerEmail") Your Email
		input#registerEmail.form-control(type="email")
	.form-group
		label(for="registerRole") Role
		select.browser-default.custom-select
			option(selected disabled) Select Role
			option(value="employee") Employee
			option(value="employer") Employer
	.form-group
		label(for="registerUsername") Username
		input#registerUsername.form-control(type="text")
	.form-group
		label(for="registerPassword") Password
		input#registerPassword.form-control(type="password")
	.form-group
		label(for="registerConfirmPassword") Confirm Password
		input#registerConfirmPassword.form-control(type="password")
	
	button.btn.btn-primary.w-100.mx-auto(@click="submitForm") Register

</template>

<script lang="coffee">
export default{
	methods: {
		submitForm: ->
			if(process.client)
				localStorage.setItem("login", true)
				localStorage.setItem("role", false)
				window.location.reload()
	}
}
</script>

<style lang="stylus" scoped></style>
