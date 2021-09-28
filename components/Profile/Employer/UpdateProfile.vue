<template lang="pug">
form.w-50
    label(for="name") Your Name
    input#name.form-control(type="text")
    label(for="email") Your Email
    input#email.form-control(type="email")
    label(for="username") Username
    input#username.form-control(type="text")
    label(for="oldPassword") Old Password
    input#oldPassword.form-control(type="password")
    label(for="newPassword") New Password
    input#newPassword.form-control(type="password")
    label(for="confirmPassword") Confirm Password
    input#confirmPassword.form-control(type="password")

    button.btn.btn-primary Update

</template>

<script lang="coffee">
import { mdbInput, mdbBtn } from 'mdbvue'
export default {
    name: 'Profile',
    components: {
        mdbInput,
        mdbBtn
    },
}
</script>
