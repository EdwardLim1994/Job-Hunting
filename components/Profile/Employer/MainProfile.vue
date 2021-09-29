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
            Profile-Employer-UpdatePersonalProfile.py-3.containerHeight
    template(:slot="'company-profile'")
        mdbContainer
            Profile-Employer-UpdateCompanyProfile.py-3.containerHeight
    template(:slot="'created-job'")
        mdbContainer
            Profile-Employer-CreatedJob.py-3
</template>

<script lang="coffee">
import {mdbContainer, mdbTabs} from "mdbvue"
export default {
    components: {
        mdbContainer,
        mdbTabs
    }
}
</script>

<style lang="stylus" scoped>
	.containerHeight
		max-height 580px
		overflow-y auto
		overflow-x hidden
</style>