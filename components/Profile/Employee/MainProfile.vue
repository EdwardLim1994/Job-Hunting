<template lang="pug">
div
    mdbTabs(
        :active="0"
        default
        :links="[{text: 'Profile', slot:'profile'}, {text: 'Saved Job', slot:'saved-job'}]"
        :transition-duration="0.5"
        transition-style="linear"
        )
        template(:slot="'profile'")
            mdbContainer
                p.m-0.p-0.mt-4 *Fill in all the fields for the update button to show up
                Profile-Employee-UpdateProfile.py-3.containerHeight(@toast="onToast")
        //- template(:slot="'saved-job'")
        //-     mdbContainer
        //-         Profile-Employee-SavedJob.py-3.containerHeight(@showJobDetailModal="handleShowModal")
    //- Modals-ViewJobDetailModal(:modal="showModal", @closeModal="getIsCloseModal")

</template>

<script lang="coffee">
import {mdbContainer, mdbTabs} from "mdbvue"
export default {
    name: "Profile-Employee-MainProfile"
    components: {
        mdbContainer,
        mdbTabs
    }
    data: ->
        return {
            showModal: false
        }
    methods: {
        handleShowModal: ->
            @showModal = !@showModal
            return

        getIsCloseModal: ->
            @showModal = false
            return
        
        onToast: (value) ->
            @.$emit('toast', value)
    }
}
</script>

<style lang="stylus">
	.containerHeight
		max-height 580px
		min-height 580px
		overflow-y auto
		overflow-x hidden
</style>