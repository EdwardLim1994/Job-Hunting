<template lang="pug">
div
    button.btn.btn-primary(@click="setAddJobModalStatus") Add Job
    mdb-datatable-2.mt-4(v-model="data" scrollY hover maxHeight="380px"  @selected="getSelectedRow")
    Modals-AddNewJobModal(:modal="showAddJobModal", @closeModal="getIsCloseAddJobModal")
    Modals-UpdateJobModal(:modal="showUpdateJobModal", @closeModal="getIsCloseUpdateJobModal")
</template>

<script lang="coffee">
    import { mdbDatatable2 } from 'mdbvue'
    export default {
        name: 'SavedJob'
        components: {
            mdbDatatable2,
        }
        methods: {
            setAddJobModalStatus: ->
                @showAddJobModal = true
                console.log("clicked")
                return

            getIsCloseAddJobModal: ->
                @showAddJobModal = false
                return

            getIsCloseUpdateJobModal: ->
                @showUpdateJobModal = false
                return

            getSelectedRow: (e) ->
                @showUpdateJobModal = true
                console.log(e)
        }

        data: -> 
            return {
                showAddJobModal: false
                showUpdateJobModal: false
                data: {
                    columns: [
                        {
                            label: 'ID',
                            field: 'id',
                            sort: true,
                        },
                        {
                            label: 'Job Position',
                            field: 'position',
                            sort: true,
                        },
                        {
                            label: 'Experience (Year)',
                            field: 'experience',
                            sort: true,
                        },
                        {
                            label: 'Salary (RM)',
                            field: 'salary',
                            sort: true
                        },
                        {
                            label: 'Created Date',
                            field: 'createdDate',
                            sort: true,
                        }
                    ],
                    rows: [
                        {
                            id: 1,
                            position: 'Test Job 1',
                            experience: 2,
                            salary: 4000.00,
                            createdDate: '2011/04/25'
                        },
                    ],
                },
            }
    }

</script>