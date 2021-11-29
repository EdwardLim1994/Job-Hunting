import $ from "jquery"
import "jquery.cookie"
import axios from "axios"

import Notification from "./Notification.coffee"

import env from "./config/env.coffee"

class UpdateCompanyProfile
    constructor: ->
        @companyProfileImagePreview = $("#companyPreviewImage")

        @companyProfileImage = $("#updateCompanyProfileImage")
        @companyName = $("#updateCompanyName")
        @companyEmail = $("#updateCompanyEmail")
        @companyPhone = $("#updateCompanyPhone")
        @companyStreet = $("#updateCompanyStreet")
        @companyPostcode = $("#updateCompanyPostcode")
        @companyCity = $("#updateCompanyCity")
        @companyState = $("#updateCompanyState")
        @companyUrl = $("#updateCompanyUrl")

        @companyNameValidation = $("#updateCompanyNameValidation")
        @companyEmailValidation = $("#updateCompanyEmailValidation")
        @companyPhoneValidation = $("#updateCompanyPhoneValidation")
        @companyStreetValidation = $("#updateCompanyStreetValidation")
        @companyPostcodeValidation = $("#updateCompanyPostcodeValidation")
        @companyCityValidation = $("#updateCompanyCityValidation")
        @companyStateValidation = $("#updateCompanyStateValidation")
        @companyUrlValidation = $("#updateCompanyUrlValidation")
        @companyProfileImageValidation = $("#updateCompanyProfileImageValidation")

        @updateCompanyProfileForm = $("#updateCompanyProfileForm")
        @companyProfileImageForUpdate = $("#companyProfileImageForUpdate")
        @updateCompanyProfileFormSubmit = $("#updateCompanyProfileFormSubmit")
        @updateProfileContent = $("#updateProfile")
        @updateProfileTab = $("#updateProfile-tab")

        @companyProfileContent = $("#companyProfile")
        @companyProfileTab = $("#companyProfile-tab")

        @notificationClose = $("#notificationClose")

        @isCompanyFormValid = true

        @notify = new Notification()

        @event()


    event: ->
        @getOriginalCompanyProfile()
        @companyFormValidation()
        @update()
        return

    getOriginalCompanyProfile: ->
        
        if($.cookie('role') is "employer")
            response = await axios.post("#{env.BASE_URL}Company/Get.php", {
                user_id: $.cookie("id"),
            })

            callback = response.data

            switch callback.status
                when "success"
                    if(window.location.pathname is "#{env.CURRENT_PATH}/profile.html")
                        @companyName.val('').attr('placeholder', callback.data.name).attr("data-default-name", callback.data.name)
                        @companyEmail.val('').attr('placeholder', callback.data.email).attr("data-default-email", callback.data.email)
                        @companyUrl.val('').attr('placeholder', callback.data.url).attr("data-default-url", callback.data.url)
                        @companyStreet.val('').attr('placeholder', callback.data.street).attr("data-default-street", callback.data.street)
                        @companyCity.val('').attr('placeholder', callback.data.city).attr("data-default-city", callback.data.city)
                        @companyState.val(callback.data.state).attr("data-default-state", callback.data.state)
                        @companyPostcode.val('').attr('placeholder', callback.data.postcode).attr("data-default-postcode", callback.data.postcode)
                        @companyPhone.val('').attr('placeholder', callback.data.phone).attr("data-default-phone", callback.data.phone)
                        @companyProfileImage.attr("data-default-profile", callback.data.profile)
                        @companyProfileImagePreview.attr('src', "#{env.BASE_URL}upload/#{callback.data.profile}")

                        @removeFeedback(@companyName, @companyNameValidation)
                        @removeFeedback(@companyEmail, @companyEmailValidation)
                        @removeFeedback(@companyUrl, @companyUrlValidation)
                        @removeFeedback(@companyStreet, @companyStreetValidation)
                        @removeFeedback(@companyPostcode, @companyPostcodeValidation)
                        @removeFeedback(@companyState, @companyStateValidation)
                        @removeFeedback(@companyCity, @companyCityValidation)

                    break

                when "failed"
                    switch(window.location.pathname)
                        when "#{env.CURRENT_PATH}/profile.html"
                            @updateProfileContent.removeClass('active')
                            @updateProfileTab.removeClass('active')
                            @updateProfileContent.removeClass('fade show')

                            @companyProfileContent.addClass('active')
                            @companyProfileTab.addClass('active')
                            @companyProfileContent.addClass('fade show')

                        else
                            @notify.showNormalMessage("Seem you haven't register your company yet. You need to register your company before adding job.")
                            @notificationClose.on "click", ->

                                if(window.location.pathname is "#{env.CURRENT_PATH}/profile.html")
                                    @updateProfileContent.removeClass('active')
                                    @updateProfileTab.removeClass('active')
                                    @updateProfileContent.removeClass('fade show')

                                    @companyProfileContent.addClass('active')
                                    @companyProfileTab.addClass('active')
                                    @companyProfileContent.addClass('fade show')
                                else
                                    window.location.href = "http://#{env.DOMAIN}#{env.CURRENT_PATH}/profile.html#addCompany"
                    break
        
    
    update: ->
        @updateCompanyProfileForm.on "submit", ((e) ->
            e.preventDefault()
            $("#updateCompanyProfileFormSubmit").html(@loadSpinner()).attr("disabled", true)
            if(@isCompanyFormValid)
                if(window.location.hash is "#addCompany")
                    $(e.currentTarget).unbind("submit").submit()
                else
                    @companyName.val(if @companyName.val() then @companyName.val() else @companyName.data('default-name'))
                    @companyEmail.val(if @companyEmail.val() then @companyEmail.val() else @companyEmail.data('default-email'))
                    @companyUrl.val(if @companyUrl.val() then @companyUrl.val() else @companyUrl.data('default-url'))
                    @companyStreet.val(if @companyStreet.val() then @companyStreet.val() else @companyStreet.data('default-street'))
                    @companyCity.val(if @companyCity.val() then @companyCity.val() else @companyCity.data('default-city'))
                    @companyState.val(if @companyState.val() then @companyState.val() else @companyState.data('default-state'))
                    @companyPostcode.val(if @companyPostcode.val() then @companyPostcode.val() else @companyPostcode.data('default-postcode'))
                    @companyPhone.val(if @companyPhone.val() then @companyPhone.val() else @companyPhone.data('default-phone'))
                    if @companyProfileImage.val() then @companyProfileImageForUpdate.val('') else @companyProfileImageForUpdate.val(@companyProfileImage.data("default-profile"))

                    $(e.currentTarget).unbind("submit").submit()
            else
                @notify.showErrorMessage("Some input is/are invalid.")
                return false

        ).bind(@)
        return

    companyFormValidation: ->
        isNameValid = false
        isEmailValid = false
        isPhoneValid = false
        isStreetValid = false
        isPostcodeValid = false
        isCityValid = false
        isStateValid = false

        @companyProfileImage.on 'change', ( ->
            file = @companyProfileImage.get(0).files[0]
            if (file)
                @previewImage(@companyProfileImagePreview, file)
                @updateCompanyProfileFormSubmit.attr("disabled", false)
            return
        ).bind(@)

        @companyName.on "focusout", (->
            if(@companyName.val())
                @verifyingFeedback(@companyName, @companyNameValidation, "Verifying....")
                response = await axios.post("#{env.BASE_URL}Company/Validate.php", {
                    checkType: "name"
                    input: @companyName.val()
                })
                callback = response.data

                switch callback.status
                    when "failed"
                        @invalidFeedback(@companyName, @companyNameValidation, callback.message)
                        isNameValid = false
                    when "success"
                        @validFeedback(@companyName, @companyNameValidation, "Looks Good")
                        isNameValid = true

            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyName, @companyNameValidation, "This is required field")
                    isNameValid = false
                else
                    @removeFeedback(@companyName, @companyNameValidation)
                    isNameValid = true
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        ).bind(@)

        @companyEmail.on "focusout", (->
            if(@companyEmail.val())
                if(@validateEmail(@companyEmail.val()))
                    @verifyingFeedback(@companyEmail, @companyEmailValidation, "Verifying....")
                    response = await axios.post("#{env.BASE_URL}Company/Validate.php", {
                        checkType: "email"
                        input: @companyEmail.val()
                    })

                    callback = response.data

                    switch callback.status
                        when "failed"
                            @invalidFeedback(@companyEmail, @companyEmailValidation, callback.message)
                            isEmailValid = false
                        when "success"
                            @validFeedback(@companyEmail, @companyEmailValidation, "Looks Good")
                            isEmailValid = true

                else
                    @invalidFeedback(@companyEmail, @companyEmailValidation, "This is not a valid email")
                    isEmailValid = true
            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyEmail, @companyEmailValidation, "This is required field")
                    isEmailValid = false
                else
                    @removeFeedback(@companyEmail, @companyEmailValidation)
                    isEmailValid = true
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        ).bind(@)

        @companyPhone.on "focusout", (->

            if(@companyPhone.val())
                if(@validatePhone(@companyPhone.val()))
                    @validFeedback(@companyPhone, @companyPhoneValidation, "Looks Good")
                    isPhoneValid = true
                else
                    @invalidFeedback(@companyPhone, @companyPhoneValidation, "This is not a valid phone number")
                    isPhoneValid = false
            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyPhone, @companyPhoneValidation, "This is required field")
                    isPhoneValid = false
                else
                    @removeFeedback(@companyPhone, @companyPhoneValidation)
                    isPhoneValid = true
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        ).bind(@)

        @companyStreet.on "focusout", (->

            if(@companyStreet.val())
                @validFeedback(@companyStreet, @companyStreetValidation, "Looks Good")
                isStreetValid = true
            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyStreet, @companyStreetValidation, "This is required field")
                    isStreetValid = false
                else
                    @removeFeedback(@companyStreet, @companyStreetValidation)
                    isStreetValid = true
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        
        ).bind(@)

        @companyPostcode.on "focusout", (->
            if(@companyPostcode.val())
                if(@validatePostcode(@companyPostcode.val()))
                    @validFeedback(@companyPostcode, @companyPostcodeValidation, "Looks Good")
                    isPostcodeValid = true
                else
                    @invalidFeedback(@companyPostcode, @companyPostcodeValidation, "Postcode must be exactly 5 digits long")
                    isPostcodeValid = false
            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyPostcode, @companyPostcodeValidation, "This is required field")
                    isPostcodeValid = false
                else
                    @removeFeedback(@companyPostcode, @companyPostcodeValidation)
                    isPostcodeValid = true
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        ).bind(@)

        @companyCity.on "focusout", (->

            if(@companyCity.val())
                @validFeedback(@companyCity, @companyCityValidation, "Looks Good")
                isCityValid = true
            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyCity, @companyCityValidation, "This is required field")
                    isCityValid = false
                else
                    @removeFeedback(@companyCity, @companyCityValidation, "This is required field")
                    isCityValid = true
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        ).bind(@)

        @companyState.on "focusout", (->

            if(@companyState.val())
                @validFeedback(@companyState, @companyStateValidation, "Looks Good")
                isStateValid = true
            else
                if(window.location.hash is "#addCompany")
                    @invalidFeedback(@companyState, @companyStateValidation, "This is required field")
                    isStateValid = false
                else
                    @removeFeedback(@companyState, @companyStateValidation)
                    isStateValid = false
            @confirmCompanyFormValidation(isNameValid, isEmailValid, isPhoneValid, isStreetValid, isPostcodeValid, isCityValid, isStateValid)
        ).bind(@)

        # @companyUrl.on "focusout", (->

        #     if(@companyUrl.val())
        #         @validFeedback(@companyUrl, @companyUrlValidation, "Looks Good")
        #         if(not window.location.hash)
        #             @updateCompanyProfileFormSubmit.attr("disabled", false)
        #     else
        #         if(not window.location.hash and @companyProfileImage.val() is '')
        #             @updateCompanyProfileFormSubmit.attr("disabled", true)

        #         @removeFeedback(@companyUrl, @companyUrlValidation)
        # ).bind(@)
        return

    confirmCompanyFormValidation: (nameValidate, emailValidate, phoneValidate, streetValidate, postcodeValidate, cityValidate, stateValidate) ->
        if(window.location.hash is "#addCompany")
            if(nameValidate is true and emailValidate is true and phoneValidate is true and streetValidate is true and postcodeValidate is true and cityValidate is true and stateValidate is true)
                @isCompanyFormValid = true
                @updateCompanyProfileFormSubmit.attr("disabled", false)
            else
                @isCompanyFormValid = false
                @updateCompanyProfileFormSubmit.attr("disabled", true)
        else
            if(nameValidate is true or emailValidate is true or phoneValidate is true or streetValidate is true or postcodeValidate is true or cityValidate is true or stateValidate is true)
                @isCompanyFormValid = true
                @updateCompanyProfileFormSubmit.attr("disabled", false)
            else
                @isCompanyFormValid = false
                @updateCompanyProfileFormSubmit.attr("disabled", true)

        
        return


    removeFeedback: (inputTag, notificationTag) ->
        inputTag.attr('title', '')
        inputTag.removeClass('is-invalid is-valid')
        notificationTag.removeClass('invalid-feedback valid-feedback').empty()
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

    previewImage: (previewImageContainer, file) ->
        reader = new FileReader()
        reader.onload = (() ->
            previewImageContainer.attr('src', reader.result)
        ).bind(@)
        reader.readAsDataURL(file)
        return

    validateEmail: (email) ->
        return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)

    validatePostcode: (postcode) ->
        return /^(\d{5})?$/.test(postcode)

    validatePhone: (phone) ->
        return /^(?:(01)[0-46-9]|(0)[2-79]|(08)[0-9])-*[0-9]{7,8}$/.test(phone)
        

    loadSpinner: ->
        return '
            <div class="spinner-border" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        '

export default UpdateCompanyProfile