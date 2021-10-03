<template lang="pug">
form(@submit.prevent)
	.form-group
		label(for="loginUsername") Username / Email
		input#loginUsername.form-control(v-model="usernameORemail" type="text")
	.form-group
		label(for="loginPassword") Password
		input#loginPassword.form-control(v-model="password" type="password")
		.text-right
			a.text-primary Forget Password
	
	button.btn.w-100.mx-auto(
		v-if="isAllInputValid" 
		:disabled="isSubmitting || isSubmittedSuccess" 
		type="submit"
		:class="isSubmitted ? 'btn-success' : 'btn-primary'"
		@click="submitForm"
	) 
		Spinner(v-if="isSubmitting && !isSubmitted")
		span(v-else-if="!isSubmitting & isSubmitted") {{ isSubmittedSuccess ? 'Success' : 'Login' }}
		span(v-else) Login

</template>

<script lang="coffee">
import CryptoJS from 'crypto-js'
import encHex from 'crypto-js/enc-hex'
import padZeroPadding from 'crypto-js/pad-zeropadding'
export default{

	data: ->
		return {
			usernameORemail: ""
			password: ""
			isSubmitting: false
			isSubmitted: false
			isSubmittedSuccess: false
		}

	computed: {
		isAllInputValid: ->
			if(@usernameORemail and @password)
				return true
			else
				return false
	}

	methods: {

		submitForm: ->
			@isSubmitting = true
			@isSubmitted = false
			response = await @.$axios.post(process.env.BASE_URL + 'Users/Login.php', {
					usernameORemail: @usernameORemail
					password: CryptoJS.AES.encrypt(@password, encHex.parse(process.env.KEY), {iv: encHex.parse(process.env.IV), padding: padZeroPadding}).toString()
			})

			callback = response.data
			switch callback.status
				when "success"
					setTimeout(( ->
						@isSubmitting = false
						@isSubmitted = true
						@isSubmittedSuccess = true
						localStorage.setItem('id', callback.data.id)
						localStorage.setItem('role', callback.data.role)
						localStorage.setItem('token', callback.data.token)
						setTimeout( (->
							window.location.reload()
						).bind(@), 2000)
					).bind(@), 3000)
					
					
				when "failed"
					setTimeout((->
						@isSubmitting = false
						@isSubmitted = true	
						@isSubmittedSuccess = false
						@.$emit('toast', {header: 'Failed', message: callback.message})
					).bind(@), 3000)
					

				when "error"
					setTimeout((->
						@isSubmitting = false
						@isSubmitted = true	
						@isSubmittedSuccess = false
						@.$emit('toast', {header: 'Error', message: callback.message})
					).bind(@), 3000)
					
	}
}
</script>

<style lang="stylus" scoped></style>
