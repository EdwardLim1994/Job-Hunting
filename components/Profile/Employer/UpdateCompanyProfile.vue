<template lang="pug">
form
    .form-group
        label(for="updateCompanyProfile") Company Profile
        #preview
            img(:src="url")
        input#updateCompanyProfile.mt-2(type="file", @change="onFileChange")
        
        
    .form-group
        label(for="updateEmployerName") Your Name
        input#updateEmployerName.form-control(type="text")
    .form-group
        label(for="updateCompanyEmail") Company Name
        input#updateCompanyEmail.form-control(type="text")
    .form-group
        label(for="updateCompanyEmail") Company Email
        input#updateCompanyEmail.form-control(type="email")
    .form-group
        label(for="updateCompanyPhone") Company Phone Number
        input#updateCompanyPhone.form-control(type="tel")
    .form-group
        label(for="updateCompanyStreet") Street
        input#updateCompanyStreet.form-control(type="text")
    .form-group
        .row
            .col-12.col-md-4
                label(for="updateCompanyPostcode") Postcode
                input#updateCompanyPostcode.form-control(type="number")
            .col-12.col-md-4
                label(for="updateCompanyCity") Postcode
                input#updateCompanyCity.form-control(type="text")
            .col-12.col-md-4
                label(for="updateCompanyState") State
                input#updateCompanyState.form-control(type="text")
    .form-group
        label(for="updateCompanyUrl") Company Website URL
        input#updateCompanUrl.form-control(type="text")

    button.btn.btn-primary.mx-auto Update

</template>

<script lang="coffee">
import { mdbInput, mdbBtn } from 'mdbvue'
export default {
    name: 'Profile',
    components: {
        mdbInput,
        mdbBtn
    },
    data: ->
        return{
            url: "placeholder-images-image_large.png"
        }
    methods: {
        onFileChange: (e) ->
            file = e.target.files[0]
            @url = URL.createObjectURL(file)

    }
}
</script>

<style lang="stylus" scoped>
	#preview
		display flex
		align-items center

		img
			border 2px solid grey
			border-radius 5px
			max-width 200px !important
			max-height 200px !important
</style>
