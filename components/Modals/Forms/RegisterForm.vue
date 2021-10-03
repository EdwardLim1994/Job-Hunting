<template lang="pug">
form.needs-validation(@submit.prevent @submit="submitForm")
	.form-group
		label(for="registerName") Your Name
		input#registerName.form-control(
			v-model="name" 
			@blue="checkName"
			name="name"
			type="text" 
			required
		)
	.form-group
		label(for="registerEmail") Your Email
		input#registerEmail.form-control(
			v-model="email.input" 
			@blur="checkUniqueEmail" 
			:class="email.validate.class"
			:title="email.validate.title"
			name="email" 
			type="email" 
			required
		)
		div(
			v-show="email.input && !email.isValid" 
			:class="email.input && !email.isValid ? 'invalid-feedback' : ''"
		) {{email.validate.title}}
	.form-group
		label(for="registerRole") Role
		select.browser-default.custom-select(
			v-model="role.input" 
			@blur="checkRoleIsSelected"
			:class="role.validate.class"
			:title="role.validate.title"
			name="role" 
			required
		)
			option(selected disabled) Select Role
			option(value="employee") Employee
			option(value="employer") Employer
		div(
			v-show="role.input && !role.isValid" 
			:class="role.input && !role.isValid ? 'invalid-feedback' : ''"
		) {{role.validate.title}}
	.form-group
		label(for="registerUsername") Username
		input#registerUsername.form-control(
			v-model="username.input" 
			@blur="checkUniqueUsername" 
			:class="username.validate.class"
			:title="username.validate.title"
			name="username" 
			type="text" 
			required
		)
		div(
			v-show="username.input && !username.isValid" 
			:class="username.input && !username.isValid ? 'invalid-feedback' : ''"
		) {{username.validate.title}}
	.form-group
		label(for="registerPassword") Password
		input#registerPassword.form-control(
			v-model="password.input" 
			@blur="checkPasswordFollowingPattern"
			:class="password.validate.class"
			:title="password.validate.title"
			name="password"
			type="password" 
			required
		)
		div(
			v-show="password.input && !password.isValid	" 
			:class="password.input && !password.isValid ? 'invalid-feedback' : ''"
		) {{password.validate.title}}
	.form-group
		label(for="registerConfirmPassword") Confirm Password
		input#registerConfirmPassword.form-control(
			v-model="confirmPassword.input" 
			@blur="checkConfirmPasswordMatchWithPassword"
			:class="confirmPassword.validate.class"
			:title="confirmPassword.validate.title"
			name="confirmPassword" 
			type="password" 
			required
		)
		div(
			v-show="confirmPassword.input && !confirmPassword.isValid " 
			:class="confirmPassword.input && !confirmPassword.isValid ? 'invalid-feedback' : ''"
		) {{confirmPassword.validate.title}}

	button.btn.w-100.mx-auto(
		v-if="isAllInputValid" 
		:disabled="isSubmitting || isSubmittedSuccess" 
		type="submit"
		:class="isSubmittedSuccess ? 'btn-success' : 'btn-primary'"
	) 
		Spinner(v-if="isSubmitting && !isSubmitted")
		span(v-else-if="!isSubmitting & isSubmitted") {{ isSubmittedSuccess ? 'Success' : 'Register' }}
		span(v-else) Register

</template>

<script lang="coffee">
import CryptoJS from 'crypto-js'
import encHex from 'crypto-js/enc-hex'
import padZeroPadding from 'crypto-js/pad-zeropadding'
export default{
	data: ->
		return {
			name: ''
			isAllInputValid: false
			isSubmitting: false
			isSubmitted: false
			isSubmittedSuccess: false
			email: {
				input: ''
				isValid: false
				validate: {
					class: ""
					title: ""
				}
			}
			role: {
				input: ''
				isValid: false
				validate: {
					class: ""
					title: ""
				}
			}
			username: {
				input: ''
				isValid: false
				validate: {
					class: ""
					title: ""
				}
			}
			password: {
				input: ''
				isValid: false
				validate: {
					class: ""
					title: ""
				}
			}
			confirmPassword: {
				input: ''
				isValid: false
				validate: {
					class: ""
					title: ""
				}
			}
		}
	fetchOnServer: false
	methods: {
		checkName: ->
			@checkIsAllInputValid()
			return

		checkUniqueEmail: ->
			if(@email.input)
				response = await @.$axios.post(process.env.BASE_URL + "Users/Validate.php", {
					checkType: "email"
					input: @email.input
				})

				callback = response.data

				switch callback.status
					when "failed"
						@email.isValid = false
						@email.validate.class = 'is-invalid'
						@email.validate.title = callback.message
					when "success"
						@email.isValid = true
						@email.validate.class = 'is-valid'
						@email.validate.title = ''
			@checkIsAllInputValid()
			return

		checkUniqueUsername: ->
			if(@username.input)
				response = await @.$axios.post(process.env.BASE_URL + "Users/Validate.php", {
					checkType: "username"
					input: @username.input
				})
				callback = response.data
				switch callback.status
					when "failed"
						@username.isValid = false
						@username.validate.class = 'is-invalid'
						@username.validate.title = callback.message
					when "success"
						@username.isValid = true
						@username.validate.class = 'is-valid'
						@username.validate.title = callback.message
			@checkIsAllInputValid()
			return

		checkPasswordFollowingPattern: ->
			if(/^(\d|\D){6,}$/.test(@password.input))
				@password.isValid = true
				@password.validate.class = 'is-valid'
				@password.validate.title = ''
			else
				@password.isValid = false
				@password.validate.class = 'is-invalid'
				@password.validate.title = 'Password must contains at least 6 characters with alphabets and numeric'
			@checkIsAllInputValid()
			return

		checkConfirmPasswordMatchWithPassword: ->
			if(@password.input and @confirmPassword.input)
				if(@password.input is @confirmPassword.input)
					@confirmPassword.isValid = true
					@confirmPassword.validate.class = 'is-valid'
					@confirmPassword.validate.title = ''
				else
					@confirmPassword.isValid = false
					@confirmPassword.validate.class = 'is-invalid'
					@confirmPassword.validate.title = 'Confirm password is not match with password'

			@checkIsAllInputValid()
			return

		checkRoleIsSelected: ->
			if(@role.input)
				@role.isValid = true
				@role.validate.class = 'is-valid'
				@role.validate.title = ''
			else
				@role.isValid = false
				@role.validate.class = 'is-invalid'
				@role.validate.title = 'Role must be selected'
			
			@checkIsAllInputValid()
			return

		checkIsAllInputValid: ->
			if(@email.isValid and @username.isValid and @password.isValid and @confirmPassword.isValid)
				@isAllInputValid = true
			else
				@isAllInputValid = false
			return

		submitForm: (e) ->

			@checkRoleIsSelected()

			if(@role.isValid)
				@isSubmitting = true
				@isSubmitted = false

				response = await @.$axios.post("#{process.env.BASE_URL}Users/Register.php", {
						name: @name,
						email: @email.input,
						username: @username.input,
						role: @role.input,
						password: CryptoJS.AES.encrypt(@password.input, encHex.parse(process.env.KEY), {iv: encHex.parse(process.env.IV), padding: padZeroPadding}).toString()
				})
				
				callback = response.data
				console.log(callback)
				switch callback.status
					when "success"
						setTimeout( (->
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
						setTimeout( (->
							@isSubmitting = false
							@isSubmitted = true	
							@isSubmittedSuccess = false
							@.$emit('toast', {header: 'Failed', message: callback.message})
						).bind(@), 3000)
						

					when "error"
						setTimeout( (->
							@isSubmitting = false
							@isSubmitted = true	
							@isSubmittedSuccess = false
							@.$emit('toast', {header: 'Error', message: callback.message})
						).bind(@), 3000)
						


	}

	fetchOnServer: false
	
}
</script>

<style lang="stylus" scoped></style>
