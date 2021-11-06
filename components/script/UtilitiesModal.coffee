class UtilitiesModal
    constructor: ->
        @title = $("#utilitiesTitle")
        @header = $("#utilitiesHeader")
        @modalType = $("#utilitiesType")
        
        @addJobForm = $("#addJobForm")
        @updateJobForm = $("#updateJobForm")
        @deleteJobForm = $("#deleteJobForm")
        @viewJobForm = $("#viewJobForm")

        @addJobButtonGroup = $("#addJobButtonGroup")
        @updateJobButtonGroup = $("#updateJobButtonGroup")
        @deleteJobButtonGroup = $("#deleteJobButtonGroup")
        
    
    setAddJobModal: ->
        @title.empty().text("Add Job")
        @addJobForm.removeClass("d-none").addClass("d-block")
        @updateJobForm.removeClass("d-block").addClass("d-none")
        @deleteJobForm.removeClass("d-block").addClass("d-none")
        @viewJobForm.removeClass("d-block").addClass("d-none")
        @addJobButtonGroup.removeClass("d-none").addClass("d-block")
        @updateJobButtonGroup.removeClass("d-block").addClass("d-none")
        @deleteJobButtonGroup.removeClass("d-block").addClass("d-none")
        @header.removeClass("bg-info bg-warning").addClass("bg-primary")
        @modalType.removeClass("modal-lg")
        return

    setUpdateJobModal: ->
        @title.empty().text("Update Job")
        @addJobForm.removeClass("d-block").addClass("d-none")
        @updateJobForm.removeClass("d-none").addClass("d-block")
        @deleteJobForm.removeClass("d-block").addClass("d-none")
        @viewJobForm.removeClass("d-block").addClass("d-none")
        @addJobButtonGroup.removeClass("d-block").addClass("d-none")
        @updateJobButtonGroup.removeClass("d-none").addClass("d-block")
        @deleteJobButtonGroup.removeClass("d-block").addClass("d-none")
        @header.removeClass("bg-warning bg-primary").addClass("bg-info")
        @modalType.removeClass("modal-lg")
        return

    setDeleteJobModal: ->
        @title.empty().text("Delete Job")
        @addJobForm.removeClass("d-block").addClass("d-none")
        @updateJobForm.removeClass("d-block").addClass("d-none")
        @deleteJobForm.removeClass("d-none").addClass("d-block")
        @viewJobForm.removeClass("d-block").addClass("d-none")
        @addJobButtonGroup.removeClass("d-block").addClass("d-none")
        @updateJobButtonGroup.removeClass("d-block").addClass("d-none")
        @deleteJobButtonGroup.removeClass("d-none").addClass("d-block")
        @header.removeClass("bg-primary bg-info").addClass("bg-warning")
        @modalType.removeClass("modal-lg")
        return

    setViewJobModal: ->
        @title.empty().text("View Job Detail")
        @addJobForm.removeClass("d-block").addClass("d-none")
        @updateJobForm.removeClass("d-block").addClass("d-none")
        @deleteJobForm.removeClass("d-block").addClass("d-none")
        @viewJobForm.removeClass("d-none").addClass("d-block")
        @addJobButtonGroup.removeClass("d-block").addClass("d-none")
        @updateJobButtonGroup.removeClass("d-block").addClass("d-none")
        @deleteJobButtonGroup.removeClass("d-block").addClass("d-none")
        @header.removeClass("bg-info bg-warning").addClass("bg-primary")
        @modalType.addClass("modal-lg")
        return

export default UtilitiesModal