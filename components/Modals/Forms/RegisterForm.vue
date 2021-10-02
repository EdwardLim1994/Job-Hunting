<template lang="pug">
form.needs-validation(@submit.prevent @submit="submitForm")
	.form-group
		label(for="registerName") Your Name
		input#registerName.form-control(v-model="name" name="name" type="text" required)
		
	.form-group
		label(for="registerEmail") Your Email
		input#registerEmail.form-control(v-model="email" name="email" type="email" required)
	.form-group
		label(for="registerRole") Role
		select.browser-default.custom-select(v-model="role" name="role" required)
			option(selected disabled) Select Role
			option(value="employee") Employee
			option(value="employer") Employer
	.form-group
		label(for="registerUsername") Username
		input#registerUsername.form-control(v-model="username" name="username" type="text" required)
	.form-group
		label(for="registerPassword") Password
		input#registerPassword.form-control(v-model="password" name="password" type="password" required)

	.form-group
		label(for="registerConfirmPassword") Confirm Password
		input#registerConfirmPassword.form-control(v-model="confirmPassword" name="confirmPassword" type="password" required)

	button.btn.btn-primary.w-100.mx-auto(type="submit") Register

</template>

<script lang="coffee">
import CryptoJS from 'crypto-js'
import encHex from 'crypto-js/enc-hex'
import padZeroPadding from 'crypto-js/pad-zeropadding'
export default{
	data: ->
		return {
			name: ''
			email: ''
			role: ''
			username: ''
			password: ''
			confirmPassword: ''
			isPasswordMatch: true
		}
	methods: {
		submitForm: (e) ->

			if(@password == @confirmPassword)
				response = await @.$axios.post("#{process.env.BASE_URL}Users/Register.php", {
						name: @name,
						email: @email,
						username: @username,
						role: @role,
						password: CryptoJS.AES.encrypt(@password, encHex.parse(process.env.KEY), {iv: encHex.parse(process.env.IV), padding: padZeroPadding}).toString()
					})
				
				callback = response.data

				switch callback.status
					when "success"
						localStorage.setItem('id', callback.data.id)
						localStorage.setItem('role', callback.data.role)
						localStorage.setItem('token', callback.data.token)
						window.location.reload()
					when "failed"
						@.$emit('toast', {header: 'Failed', message: callback.message})

					when "error"
						@.$emit('toast', {header: 'Error', message: callback.message})

			else
				@.$emit('toast', {header: 'Failed', message: 'Password Not Match'})

	}

	fetchOnServer: false
	
}
</script>

<style lang="stylus" scoped></style>
