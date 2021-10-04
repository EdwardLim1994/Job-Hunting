<template lang="pug">
form.w-75(@submit.prevent @submit="submitForm")
    .form-group
        label(for="updateName") Your Name
        input#updateName.form-control(
            v-model="name.input"
            @blur="checkName"
            name="name"
            type="text"
            required
        )
    .form-group
        label(for="updateEmail") Your Email
        input#updateEmail.form-control(
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
        label(for="updateUsername") Username
        input#updateUsername.form-control(
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
        label(for="updatePassword") New Password
        input#updatePassword.form-control(
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
        label(for="updateConfirmPassword") Confirm Password
        input#updateConfirmPassword.form-control(
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

    button.btn.btn-primary.mx-auto Update
</template>

<script lang="coffee">
import CryptoJS from 'crypto-js'
import encHex from 'crypto-js/enc-hex'
import padZeroPadding from 'crypto-js/pad-zeropadding'
export default {
    name: 'Profile',
    data: ->
        return {
            isAllInputValid: false
            isSubmitting: false
            isSubmitted: false
            isSubmittedSuccess: false
            name: {
                input: ''
            }
            email: {
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
    fetch: ->
        response = await @.$axios.post("#{process.env.BASE_URL}Users/Get.php", {
            id: localStorage.getItem('id')
        })

        callback = response.data
        switch callback.status
            when 'success'
                @email.input = callback.data.email
                @username.input = callback.data.username
                @name.input = callback.data.name
            when 'failed'
                @.$emit('toast', {header: 'Failed', message: callback.message})


        return

    methods: {

        checkName: ->
            @checkIsAllInputValid()
            return

        checkUniqueEmail: ->
            if(@email.input)
                response = await @.$axios.post(process.env.BASE_URL + "Users/Validate.php", {
                    checkType: "updateEmail"
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
            else
                @email.isValid = false
                @email.validate.class = ''
                @email.validate.title = ''
            @checkIsAllInputValid()
            return
        checkUniqueUsername: ->
            if(@username.input)
                response = await @.$axios.post(process.env.BASE_URL + "Users/Validate.php", {
                    checkType: "updateUsername"
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

        checkIsAllInputValid: ->
            if(@email.isValid and @username.isValid and @password.isValid and @confirmPassword.isValid)
                @isAllInputValid = true
            else
                @isAllInputValid = false
            return

        submitForm: ->
            return
    }
}
</script>
