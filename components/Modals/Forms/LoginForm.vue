<template lang="pug">
form(@submit.prevent)
	.form-group
		label(for="loginUsername") Username
		input#loginUsername.form-control(v-model="username" type="text")
	.form-group
		label(for="loginPassword") Password
		input#loginPassword.form-control(v-model="password" type="password")
		.text-right
			a.text-primary Forget Password
	
	button.btn.btn-primary.w-100.mx-auto(@click="submitForm") Login

</template>

<script lang="coffee">
import CryptoJS from 'crypto-js'
import encHex from 'crypto-js/enc-hex'
import padZeroPadding from 'crypto-js/pad-zeropadding'
export default{

	data: ->
		return {
			username: ""
			password: ""
		}

	methods: {
		submitForm: ->

			response = await @.$axios.post(process.env.BASE_URL + 'Users/Login.php', {
				username: @username
				password: CryptoJS.AES.encrypt(@password, encHex.parse(process.env.KEY), {iv: encHex.parse(process.env.IV), padding: padZeroPadding}).toString()
			})

			callback = response.data
			console.log callback
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

	}
}
</script>

<style lang="stylus" scoped></style>
