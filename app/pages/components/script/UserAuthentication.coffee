import $ from "jquery"
import "jquery.cookie"
import axios from "axios"
import CryptoJS from "crypto-js"
import encHex from 'crypto-js/enc-hex'
import padZeroPadding from 'crypto-js/pad-zeropadding'

import env from "./config/env.coffee"

import Notification from "./Notification.coffee"

class UserAuthentication
    constructor: ->

        @loginFormSubmit = $("#loginFormSubmit")
        @registerFormSubmit = $("#registerFormSubmit")
        @updateProfileFormSubmit = $("#updateProfileFormSubmit")
        @triggerLogout = $("#triggerLogout")
        @closeModal = $("#closeModal")

        @loginUsernameEmail = $("#loginUsernameEmail")
        @loginPassword = $("#loginPassword")

        @loginUsernameEmailValidation = $("#loginUsernameEmailValidation")
        @loginPasswordValidation = $("#loginPasswordValidation")

        @registerRole = $("#registerRole")
        @registerUsername = $("#registerUsername")
        @registerEmail = $("#registerEmail")
        @registerName = $("#registerName")
        @registerPassword = $("#registerPassword")
        @registerConfirmPassword = $("#registerConfirmPassword")

        @registerRoleValidation = $("#registerRoleValidation")
        @registerUsernameValidation = $("#registerUsernameValidation")
        @registerEmailValidation = $("#registerEmailValidation")
        @registerNameValidation = $("#registerNameValidation")
        @registerPasswordValidation = $("#registerPasswordValidation")
        @registerConfirmPasswordValidation = $("#registerConfirmPasswordValidation")

        @updateUsername = $("#updateUsername")
        @updateEmail = $("#updateEmail")
        @updateName = $("#updateName")
        @updatePassword = $("#updatePassword")
        @updateConfirmPassword = $("#updateConfirmPassword")

        @updateUsernameValidation = $("#updateUsernameValidation")
        @updateEmailValidation = $("#updateEmailValidation")
        @updateNameValidation = $("#updateNameValidation")
        @updatePasswordValidation = $("#updatePasswordValidation")
        @updateConfirmPasswordValidation = $("#updateConfirmPasswordValidation")

        @isLoginFormValid = false
        @isRegisterFormValid = false
        @isUpdateFormValid = false

        @notify = new Notification()

        @event()

    event: ->
        @checkLoginState()
        @registerFormValidation()
        @loginFormValidation()
        @updateFormValidation()
        @loginFormSubmit.on "click", (->
            @login()
        ).bind(@)
        @registerFormSubmit.on "click", (->
            @register()
        ).bind(@)
        @triggerLogout.one "click", (->
            @logout()
        ).bind(@)
        @update()
        return

    checkLoginState: ->

        if $.cookie('id') and $.cookie('token')
            response = await axios.post("#{env.BASE_URL}Users/Status.php", {
                id: $.cookie('id'),
                token: $.cookie('token') ,
            })
            callback = response.data
            switch (callback.status)
                when 'success'
                    $.cookie('role', callback.data.role)

                when 'failed'
                    $.removeCookie('id', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                    $.removeCookie('token', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                    $.removeCookie('role', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                    window.location.href = "#{env.CURRENT_PATH}"
        else
            if window.location.href.indexOf("profile.html") > -1
                $.removeCookie('id', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                $.removeCookie('token', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                $.removeCookie('role', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                window.location.href = "#{env.CURRENT_PATH}"
        return

    logout: ->
        
        @triggerLogout.empty().html(@loadSpinner())
        setTimeout((->
            $.ajax({
                method: 'POST'
                url: "#{env.BASE_URL}Users/Logout.php"
                data: {
                    id: $.cookie('id')
                }
                success: ((response) ->

                    callback = JSON.parse(response)

                    switch callback.status
                        when "success"
                            $.removeCookie('id', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                            $.removeCookie('token', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                            $.removeCookie('role', { path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                            setTimeout( ->
                                window.location.href = "#{env.CURRENT_PATH}"
                            , 2000)
                        when "failed"
                            @triggerLogout.empty().text("Logout")
                            @notify.showErrorMessage(callback.message)
                            window.location = "#notify"
                ).bind(@)
                error: ((e) ->
                    @notify.showErrorMessage(e.responseText)
                    window.location = "#notify"
                ).bind(@)
            })
        ).bind(@), 1000)


    login: ->

        @loginFormSubmit.html(@loadSpinner()).attr("disabled", true)
        @closeModal.attr("disabled", true)
        if(@isLoginFormValid is true)
            $.ajax({
                method: 'POST'
                url: "#{env.BASE_URL}Users/Login.php"
                data: {
                    usernameORemail: @loginUsernameEmail.val()
                    password: @encryptPassword(@loginPassword.val())
                }
                success: ((response) ->
                    callback = JSON.parse(response)

                    setTimeout((->

                        switch callback.status
                            when "success"
                                @loginFormSubmit.removeClass("btn-primary").addClass("btn-success").text("Success! Logging in...")
                                $.cookie('id', callback.data.id, { expires: 2, path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                                $.cookie('role', callback.data.role, { expires: 2, path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                                $.cookie('token', callback.data.token, { expires: 2, path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                                setTimeout( ->
                                    window.location.reload("/")
                                , 2000)
                            when "failed"
                                @loginFormSubmit.removeClass("btn-primary").addClass("btn-danger").text(callback.message)
                                @closeModal.attr("disabled", false)
                                setTimeout(( ->
                                    @loginFormSubmit.removeClass("btn-danger").addClass("btn-primary").attr('disabled', false).text("Login")
                                ).bind(@), 2000)
                    ).bind(@), 3000)
                ).bind(@)
                error: ((e) ->
                    @notify.showErrorMessage(e.responseText)
                    @closeModal.attr("disabled", false)
                    @loginFormSubmit.removeClass("btn-danger").addClass("btn-primary").attr('disabled', false).text("Login")
                    window.location = "#notify"
                    return
                ).bind(@)
            })
        return

    register: ->
        @closeModal.attr("disabled", true)
        @registerFormSubmit.html(@loadSpinner()).attr("disabled", true)

        if(@isRegisterFormValid is true)
            $.ajax({
                method: 'POST'
                url: "#{env.BASE_URL}Users/Register.php"
                data: {
                    name: @registerName.val()
                    email: @registerEmail.val()
                    username: @registerUsername.val()
                    role: @registerRole.val()
                    password: @encryptPassword(@registerPassword.val())
                }
                success: ((response) ->
                    callback = JSON.parse(response)
                    setTimeout((->
                        switch callback.status
                            when "success"
                                @registerFormSubmit.removeClass("btn-primary").addClass("btn-success").text("Success! Logging in...")
                                $.cookie('id', callback.data.id, { expires: 1, path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                                $.cookie('role', callback.data.role, { expires: 1, path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                                $.cookie('token', callback.data.token, { expires: 1, path: "#{env.CURRENT_PATH}", domain: "#{env.DOMAIN}" })
                                setTimeout( ->
                                    window.location.reload("/")
                                , 2000)
                            when "failed"
                                @registerFormSubmit.removeClass("btn-primary").addClass("btn-danger").text(callback.message)
                                @closeModal.attr("disabled", false)
                                setTimeout(( ->
                                    @registerFormSubmit.removeClass("btn-danger").addClass("btn-primary").attr('disabled', false).text("Register")
                                ).bind(@), 2000)
                    ).bind(@), 3000)
                    return
                ).bind(@)
                error: ((e) ->
                    @notify.showErrorMessage(e.responseText)
                    @closeModal.attr("disabled", false)
                    window.location = "#notify"
                    @registerFormSubmit.removeClass("btn-danger").addClass("btn-primary").attr('disabled', false).text("Register")
                    return
                ).bind(@)
            })

        return


    update: ->
        @getOriginalUserProfile()

        @updateProfileFormSubmit.on "click", (->

            @updateProfileFormSubmit.html(@loadSpinner()).attr("disabled", true)

            $.ajax({
                method: "POST"
                url: "#{env.BASE_URL}Users/Update.php"
                data: {
                    id: $.cookie('id')
                    name: if @updateName.val() then @updateName.val() else @updateName.data('default-name')
                    email: if @updateEmail.val() then @updateEmail.val() else @updateEmail.data('default-email')
                    username: if @updateUsername.val() then @updateUsername.val() else @updateUsername.data('default-username')
                    password: if @updatePassword.val() then @encryptPassword(@updatePassword.val()) else ''
                }
                success: ((response) ->
                    
                    callback = JSON.parse(response)

                    setTimeout((->
                        switch callback.status
                            when "success"
                                @updateProfileFormSubmit.attr('disabled', false).text("Update")
                                @notify.showSuccessMessage("Profile has been successfully updated")
                                @getOriginalUserProfile()
                            when "failed"
                                @updateProfileFormSubmit.attr('disabled', false).text("Update")
                                @notify.showErrorMessage(callback.message)
                                window.location = "#notify"
                    ).bind(@), 2000)

                    return

                ).bind(@)

                error: ((e) ->
                    @updateProfileFormSubmit.attr('disabled', false).text("Update")
                    @notify.showErrorMessage(e.responseText)
                    window.location = "#notify"
                    return
                ).bind(@)
            })
        ).bind(@)

    getOriginalUserProfile: ->
        response = await axios.post("#{env.BASE_URL}Users/Get.php", {
            id: $.cookie('id')
        })

        callback = response.data

        switch callback.status
            when "success"
                
                @updateName.val('').attr('placeholder', callback.data.name).attr('data-default-name', callback.data.name)
                @updateEmail.val('').attr('placeholder', callback.data.email).attr('data-default-email', callback.data.email)
                @updateUsername.val('').attr('placeholder', callback.data.username).attr('data-default-username', callback.data.username)
                @updatePassword.val('')
                @updateConfirmPassword.val('')

                @removeFeedback(@updateName, @updateNameValidation)
                @removeFeedback(@updateEmail, @updateEmailValidation)
                @removeFeedback(@updateUsername, @updateUsernameValidation)
                @removeFeedback(@updatePassword, @updatePasswordValidation)
                @removeFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation)

            when "failed"
                @notify.showErrorMessage(callback.message)
                window.location = "#notify"
        return

    updateFormValidation: ->
        isNameValid = false
        isEmailValid = false
        isUsernameValid = false
        isPasswordValid = false
        isConfirmPasswordValid = false

        @updateName.on "focusout", ( ->
            if(@updateName.val())
                if(@updateName.val() is @updateName.data("default-name"))
                    @invalidFeedback(@updateName, @updateNameValidation, 'Using same name. Please keep it empty for not updating name')
                    isNameValid = false
                else
                    @validFeedback(@updateName, @updateNameValidation, "Looks Good")
                    isNameValid = true
            else
                @removeFeedback(@updateName, @updateNameValidation)
                isNameValid = false
            @confirmUpdateFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid)
        ).bind(@)

        @updateEmail.on "focusout", ( ->
            if(@updateEmail.val())
                if(@updateEmail.val() is @updateEmail.data("default-email"))
                    @invalidFeedback(@updateEmail, @updateEmailValidation, 'Using same email. Please keep it empty for not updating email')
                    isNameValid = false
                else
                    @verifyingFeedback(@updateEmail, @updateEmailValidation, "Verifying....")
                    response = await axios.post("#{env.BASE_URL}Users/Validate.php", {
                        checkType: 'email'
                        input: @updateEmail.val()
                    })

                    callback = response.data

                    switch callback.status
                        when "failed"
                            @invalidFeedback(@updateEmail, @updateEmailValidation, callback.message)
                            isEmailValid = false
                        when "success"
                            @validFeedback(@updateEmail, @updateEmailValidation, "Looks Good")
                            isEmailValid = true
            else
                @removeFeedback(@updateEmail, @updateEmailValidation)
                isEmailValid = false
            @confirmUpdateFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid)
        ).bind(@)

        @updateUsername.on 'focusout', (->
            if(@updateUsername.val())
                if(@updateUsername.val() is @updateUsername.data("default-username"))
                    @invalidFeedback(@updateUsername, @updateUsernameValidation, 'Using same username. Please keep it empty for not updating username')
                    isNameValid = false
                else
                    @verifyingFeedback(@updateUsername, @updateUsernameValidation, "Verifying....")
                    response = await axios.post("#{env.BASE_URL}Users/Validate.php", {
                        checkType: 'username'
                        input: @updateUsername.val()
                    })

                    callback = response.data

                    switch callback.status
                        when "failed"
                            @invalidFeedback(@updateUsername, @updateUsernameValidation, callback.message)
                            isUsernameValid = false
                        when "success"
                            @validFeedback(@updateUsername, @updateUsernameValidation, "Looks Good")
                            isUsernameValid = true
            else
                @removeFeedback(@updateUsername, @updateUsernameValidation)
                isUsernameValid = false
            @confirmUpdateFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid)
        ).bind(@)

        @updatePassword.on 'focusout', (->
            if(@updatePassword.val())
                if(@validatePassword(@updatePassword.val()))
                    @validFeedback(@updatePassword, @updatePasswordValidation, "Looks Good")
                    isPasswordValid = true

                    if @updatePassword.val() is @updateConfirmPassword.val()
                        @validFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation, "Looks Good")
                        isConfirmPasswordValid = true
                    else
                        @invalidFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation, "Confirm password is not matched with password")
                        isConfirmPasswordValid = false
                else
            else
                if(@updateConfirmPassword.val())
                    @removeFeedback(@updatePassword, @updatePasswordValidation)
                    @invalidFeedback(@updatePassword, @updatePasswordValidation, "Both password and confirm password need to be empty for not updating password")
                    isPasswordValid = false
                else
                    @removeFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation)
                    @removeFeedback(@updatePassword, @updatePasswordValidation)
                    isPasswordValid = false
            @confirmUpdateFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid)
        ).bind(@)

        @updateConfirmPassword.on 'change', (->
            if(@updateConfirmPassword.val())
                if(@updatePassword.val())
                    if @updatePassword.val() is @updateConfirmPassword.val()
                        @validFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation, "Looks Good")
                        isConfirmPasswordValid = true
                    else
                        @invalidFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation, "Confirm password is not matched with password")
                        isConfirmPasswordValid = false
                else
                    @invalidFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation, "Password field is required")
                    isConfirmPasswordValid = false
            else
                if(@updatePassword.val())
                    @removeFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation)
                    @invalidFeedback(@updatePassword, @updatePasswordValidation, "Both password and confirm password need to be empty for not updating password")
                    isConfirmPasswordValid = false
                else
                    @removeFeedback(@updatePassword, @updatePasswordValidation)
                    @removeFeedback(@updateConfirmPassword, @updateConfirmPasswordValidation)
                    isConfirmPasswordValid = false
            @confirmUpdateFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid)
        ).bind(@)

        return

    loginFormValidation: ->
        isUsernameEmailValid = false
        isPasswordValid = false

        @loginUsernameEmail.on 'focusout', ( ->
            if(@loginUsernameEmail.val())
                @validFeedback(@loginUsernameEmail, @loginUsernameEmailValidation, 'Looks Good!')
                isUsernameEmailValid = true
            else
                @invalidFeedback(@loginUsernameEmail, @loginUsernameEmailValidation, 'This is required field')
                isUsernameEmailValid = false
            @confirmLoginFormValidation(isUsernameEmailValid, isPasswordValid)
        ).bind(@)

        @loginPassword.on 'focusout', ( ->
            if(@loginPassword.val())
                if(@validatePassword(@loginPassword.val()))
                    @validFeedback(@loginPassword, @loginPasswordValidation, 'Looks Good!')
                    isPasswordValid = true
                else
                    @invalidFeedback(@loginPassword, @loginPasswordValidation, 'Require at least 6 characters with alphabet and number')
                    isPasswordValid = false
            else
                @invalidFeedback(@loginPassword, @loginPasswordValidation, 'This is required field')
                isPasswordValid = false
            @confirmLoginFormValidation(isUsernameEmailValid, isPasswordValid)
        ).bind(@)

        return

    registerFormValidation: ->
        isNameValid = false
        isEmailValid = false
        isUsernameValid = false
        isPasswordValid = false
        isConfirmPasswordValid = false
        isRoleValid = false

        @registerName.on 'focusout', (->
            if @registerName.val()
                @validFeedback(@registerName, @registerNameValidation, "Looks Good!")
                isNameValid = true
            else
                @invalidFeedback(@registerName, @registerNameValidation, "This is required field")
                isNameValid = false
            @confirmRegisterFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid, isRoleValid)
        ).bind(@)

        @registerEmail.on 'focusout', (->
            if @registerEmail.val()

                if @validateEmail(@registerEmail.val())
                    @verifyingFeedback(@registerEmail, @registerEmailValidation, "Verifying....")
                    response = await axios.post("#{env.BASE_URL}Users/Validate.php", {
                        checkType: "email"
                        input: @registerEmail.val()
                    })
                    callback = response.data
                    switch callback.status
                        when "not found"
                            @validFeedback(@registerEmail, @registerEmailValidation, "Looks Good")
                            isEmailValid = true
                        when "failed"
                            @invalidFeedback(@registerEmail, @registerEmailValidation, callback.message)
                            isEmailValid = false
                        when "success"
                            @validFeedback(@registerEmail, @registerEmailValidation, "Looks Good")
                            isEmailValid = true
                else
                    @invalidFeedback(@registerEmail, @registerEmailValidation, "This is not an email")
                    isEmailValid = false

            else
                @invalidFeedback(@registerEmail, @registerEmailValidation, "This is required field")
                isEmailValid = false
            @confirmRegisterFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid, isRoleValid)
        ).bind(@)

        @registerUsername.on 'focusout', (->
            if @registerUsername.val()
                @verifyingFeedback(@registerUsername, @registerUsernameValidation, "Verifying....")
                response = await axios.post("#{env.BASE_URL}Users/Validate.php", {
                    checkType: "username"
                    input: @registerUsername.val()
                })
                callback = response.data
                switch callback.status
                    when "not found"
                        @validFeedback(@registerUsername, @registerUsernameValidation, "Looks Good")
                        isUsernameValid = true
                    when "failed"
                        @invalidFeedback(@registerUsername, @registerUsernameValidation, callback.message)
                        isUsernameValid = false
                    when "success"
                        @validFeedback(@registerUsername, @registerUsernameValidation, "Looks Good")
                        isUsernameValid = true
                
            else
                @invalidFeedback(@registerUsername, @registerUsernameValidation, "This is required field")
                isUsernameValid = true
            @confirmRegisterFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid, isRoleValid)
        ).bind(@)

        @registerRole.on "focusout", (->
            if @registerRole.val()
                @validFeedback(@registerRole, @registerRoleValidation, "Looks Good")
                isRoleValid = true
            else
                @invalidFeedback(@registerRole, @registerRoleValidation, "This is required field")
                isRoleValid = false
            @confirmRegisterFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid, isRoleValid)
        ).bind(@)

        @registerPassword.on 'focusout', (->
            if @registerPassword.val()
                if(@validatePassword(@registerPassword.val()))
                    @validFeedback(@registerPassword, @registerPasswordValidation, "Looks Good")
                    isPasswordValid = true

                    if @registerPassword.val() is @registerConfirmPassword.val()
                        @validFeedback(@registerConfirmPassword, @registerConfirmPasswordValidation, "Looks Good")
                        isConfirmPasswordValid = true
                    else
                        @invalidFeedback(@registerConfirmPassword, @registerConfirmPasswordValidation, "Confirm password is not matched with password")
                        isConfirmPasswordValid = false

                else
                    @invalidFeedback(@registerPassword, @registerPasswordValidation, "Require at least 6 characters with alphabet and number")
                    isPasswordValid = false
            else
                @invalidFeedback(@registerPassword, @registerPasswordValidation, "This is required field")
                isPasswordValid = false
            @confirmRegisterFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid, isRoleValid)
        ).bind(@)

        @registerConfirmPassword.on 'change', (->
            if @registerConfirmPassword.val()
                if @registerPassword.val()
                    if @registerPassword.val() is @registerConfirmPassword.val()
                        @validFeedback(@registerConfirmPassword, @registerConfirmPasswordValidation, "Looks Good")
                        isConfirmPasswordValid = true
                    else
                        @invalidFeedback(@registerConfirmPassword, @registerConfirmPasswordValidation, "Confirm password is not matched with password")
                        isConfirmPasswordValid = false
                else
                    @invalidFeedback(@registerConfirmPassword, @registerConfirmPasswordValidation, "Password field is required")
                    isConfirmPasswordValid = false
            else
                @invalidFeedback(@registerConfirmPassword, @registerConfirmPasswordValidation, "This is required field")
                isConfirmPasswordValid = false

            @confirmRegisterFormValidation(isNameValid, isEmailValid, isUsernameValid, isPasswordValid, isConfirmPasswordValid, isRoleValid)
        ).bind(@)

        return

    confirmRegisterFormValidation: (nameValidate, emailValidate, usernameValidate, passwordValidate, confirmPasswordValidate, confirmRoleValidate) ->
        if(nameValidate is true and emailValidate is true and usernameValidate is true and passwordValidate is true and confirmPasswordValidate is true and confirmRoleValidate is true)
            @isRegisterFormValid = true
            @registerFormSubmit.attr("disabled", false)
        else
            @isRegisterFormValid = false
            @registerFormSubmit.attr("disabled", true)
        return

    confirmLoginFormValidation: (usernameEmailValidate, passwordValidate) ->
        if(usernameEmailValidate is true and passwordValidate is true)
            @isLoginFormValid = true
            @loginFormSubmit.attr("disabled", false)
        else
            @isLoginFormValid = false
            @loginFormSubmit.attr("disabled", true)
        return

    confirmUpdateFormValidation: (nameValidate, emailValidate, usernameValidate, passwordValidate, confirmPasswordValidate) ->
        if(nameValidate is true or emailValidate is true or usernameValidate is true or (passwordValidate is true and confirmPasswordValidate is true))
            @isUpdateFormValid = true
            @updateProfileFormSubmit.attr("disabled", false)
        else
            @isUpdateFormValid = false
            @updateProfileFormSubmit.attr("disabled", true)
        return

    removeFeedback: (inputTag, notificationTag) ->
        inputTag.attr('title', '')
        inputTag.removeClass('is-invalid').removeClass('is-valid')
        notificationTag.removeClass('invalid-feedback').removeClass('valid-feedback').empty()
        return

    validFeedback: (inputTag, notificationTag, title) ->
        inputTag.attr('title', title)
        inputTag.removeClass('is-invalid').addClass('is-valid')
        notificationTag.removeClass('invalid-feedback').addClass('valid-feedback').text(title)
        return

    invalidFeedback: (inputTag, notificationTag, title) ->
        inputTag.attr('title', title)
        inputTag.removeClass('is-valid').addClass('is-invalid')
        notificationTag.removeClass('valid-feedback').addClass('invalid-feedback').text(title)
        return
    
    verifyingFeedback: (inputTag, notificationTag, title) ->
        inputTag.attr('title', title)
        inputTag.removeClass('is-valid').removeClass('is-invalid')
        notificationTag.removeClass('valid-feedback').removeClass('invalid-feedback').text(title)
        return

    validateEmail: (email) ->
        return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)

    validatePassword: (password) ->
        return /^(\d|\D){6,}$/.test(password)

    encryptPassword: (password) ->
        return CryptoJS.AES.encrypt(password, encHex.parse(env.KEY), { iv: encHex.parse(env.IV), padding: padZeroPadding }).toString()

    loadSpinner: ->
        return '
            <div class="spinner-border" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        '

export default UserAuthentication