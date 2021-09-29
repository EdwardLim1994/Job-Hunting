<template lang="pug">
form
    .form-group
        label(for="updateEmployerName") Your Name
        input#updateEmployerName.form-control(type="text")
    .form-group
        label(for="updateEmployerEmail") Your Email
        input#updateEmployerEmail.form-control(type="email")
    .form-group
        label(for="updateEmployerUsername") Username
        input#updateEmployerUsername.form-control(type="text")
    .form-group
        label(for="updateEmployerOldPassword") Old Password
        input#updateEmployerOldPassword.form-control(type="password")
    .form-group
        label(for="updateEmployerNewPassword") New Password
        input#updateEmployerNewPassword.form-control(type="password")
    .form-group
        label(for="updateEmployerConfirmPassword") Confirm Password
        input#updateEmployerConfirmPassword.form-control(type="password")

    button.btn.btn-primary.mx-auto Update

</template>

<script lang="coffee">
import { mdbInput, mdbBtn } from 'mdbvue'
export default {
    name: 'UpdateCompanyProfile',
    components: {
        mdbInput,
        mdbBtn
    },
}
</script>
