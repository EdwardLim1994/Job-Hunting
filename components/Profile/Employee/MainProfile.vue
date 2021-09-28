<template lang="pug">
mdbTabs(
    :active="0"
    default
    :links="[{text: 'Profile', slot:'profile'}, {text: 'Saved Job', slot:'saved-job'}]"
    :transition-duration="0.5"
    transition-style="linear"
    )
    template(:slot="'profile'")
        mdbContainer
            Profile-Employee-UpdateProfile.py-3
    template(:slot="'saved-job'")
        mdbContainer
            Profile-Employee-SavedJob
</template>

<script lang="coffee">
import {mdbContainer, mdbTabs} from "mdbvue"
export default {
    name: "Profile-Employee-MainProfile"
    components: {
        mdbContainer,
        mdbTabs
    }
}
</script>

<style lang="stylus"></style>