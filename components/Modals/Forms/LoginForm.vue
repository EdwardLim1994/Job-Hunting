<template lang="pug">
form(@submit.prevent)
	.form-group
		label(for="loginUsername") Username
		input#loginUsername.form-control(type="text")
	.form-group
		label(for="loginPassword") Password
		input#loginPassword.form-control(type="password")
		.text-right
			a.text-primary Forget Password
	
	button.btn.btn-primary.w-100.mx-auto(@click="submitForm") Login

</template>

<script lang="coffee">
export default{
	methods: {
		submitForm: ->
			if(process.client)
				localStorage.setItem("login", true)
				localStorage.setItem("role", true)
				window.location.reload()
	}
}
</script>

<style lang="stylus" scoped></style>
