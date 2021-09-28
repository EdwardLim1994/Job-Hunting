<template lang="pug">
mdbTabs(
    :active="0"
    default
    :links="[{text: 'Profile', slot:'profile'}, {text: 'Company Profile', slot:'company-profile'},{text: 'Created Job', slot: 'created-job'}]"
    :transition-duration="0.5"
    transition-style="linear"
    )
    template(:slot="'profile'")
        mdbContainer
            Profile-Employer-UpdateProfile.py-3
    template(:slot="'company-profile'")
        mdbContainer
            Profile-Employer-UpdateCompanyProfile.py-3
    template(:slot="'created-job'")
        mdbContainer
            Profile-Employer-CreatedJob.py-3
</template>

<script lang="coffee">
import {mdbContainer, mdbTabs} from "mdbvue"
export default {
    name: "Profile-Employer-MainProfile"
    components: {
        mdbContainer,
        mdbTabs
    }
}
</script>

<style lang="stylus"></style>