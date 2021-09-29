<template lang="pug">
mdbModal(size="lg",scrollable, :show="modal", @close="closeModal")
  mdbModalHeader
    mdbModalTitle Job Description
  mdbModalBody
    JobDescription
</template>

<script lang="coffee">
import {  mdbModal, mdbModalHeader, mdbModalTitle, mdbModalBody, mdbModalFooter, mdbBtn } from "mdbvue"
export default {
  components: {
    mdbModal,
    mdbModalHeader,
    mdbModalTitle,
    mdbModalBody,
    mdbModalFooter,
    mdbBtn
  }
  props: ['modal'],
  data: ->
    return {
      isOpen: false
    }
  methods: {
    closeModal: ->
      @.$emit('closeModal', false)
  }
}
</script>
