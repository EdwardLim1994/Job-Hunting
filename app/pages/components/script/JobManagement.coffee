import $ from 'jquery'
import 'jquery.cookie'

import axios from 'axios'

import UtilitiesModal from './UtilitiesModal.coffee'
import Notification from "./Notification.coffee"
import RenderEmployerJobTable from "./RenderEmployerJobTable.coffee"
import RenderEmployeeJobTable from "./RenderEmployeeJobTable.coffee"
import Loading from "./utilities/Loading.coffee"

import env from "./config/env.coffee"

class JobManagement

    constructor: ->

        @btnShowAddJobModal = $("#showAddJobModal")
        @btnAddJobSubmit = $("#addJobSubmit")
        @btnUpdateJobSubmit = $("#updateJobSubmit")
        @btnDeleteJobSubmit = $("#deleteJobSubmit")

        @addJobPosition = $("#addJobPosition")
        @addJobSalary = $("#addJobSalary")
        @addJobExperience = $("#addJobExperience")
        @addJobDescription = $("#addJobDescription")
        @addJobRequirement = $("#addJobRequirement")

        @updateJobPosition = $("#updateJobPosition")
        @updateJobSalary = $("#updateJobSalary")
        @updateJobExperience = $("#updateJobExperience")
        @updateJobDescription = $("#updateJobDescription")
        @updateJobRequirement = $("#updateJobRequirement")

        @addJobPositionValidate = $("#addJobPositionValidate")
        @addJobSalaryValidate = $("#addJobSalaryValidate")
        @addJobExperienceValidate = $("#addJobExperienceValidate")
        @addJobDescriptionValidate = $("#addJobDescriptionValidate")
        @addJobRequirementValidate = $("#addJobRequirementValidate")

        @updateJobPositionValidate = $("#updateJobPositionValidate")
        @updateJobSalaryValidate = $("#updateJobSalaryValidate")
        @updateJobExperienceValidate = $("#updateJobExperienceValidate")
        @updateJobDescriptionValidate = $("#updateJobDescriptionValidate")
        @updateJobRequirementValidate = $("#updateJobRequirementValidate")
        
        @jobDetailImage = $("#jobDetailImage")
        @jobDetailTitle = $("#jobDetailTitle")
        @jobDetailCompany = $("#jobDetailCompany")
        @jobDetailSaved = $("#jobDetailSaved")
        @jobDetailExperience = $("#jobDetailExperience")
        @jobDetailSalary = $("#jobDetailSalary")
        @jobDetailDate = $("#jobDetailDate")
        @jobDetailAddress = $("#jobDetailAddress")
        @jobDetailEmail = $("#jobDetailEmail")
        @jobDetailURL = $("#jobDetailURL")
        @jobDescriptionContent = $("#jobDescriptionContent")
        @jobRequirementContent = $("#jobRequirementContent")

        @addJobForm = $("#addJobForm")
        @updateJobForm = $("#updateJobForm")
        @deleteJobForm = $("#deleteJobForm")

        @utilitiesForm = $("#utilitiesForm")

        @updateJobID = $("#updateJobID")
        @deleteJobID = $("#deleteJobID")
        @viewJobID = $("#viewJobID")

        @userID = $("#userID")
        @userRole = $("#userRole")
        @tableRow = $("#tableRow")

        @employerTableContainer = $("#employerTableContainer")
        @employerSearchJob = $("#employerSearchJob")
        @employerRowsCurrent = $("#employerRowsCurrent")
        @employerPageCurrent = $("#employerPageCurrent")
        @employerSearchJobSubmit = $("#employerSearchJobSubmit")
        @employerTotalRows = $("#employerTotalRows")
        @employerPageTotal = $("#employerPageTotal")

        @employeeTableContainer = $("#employeeTableContainer")
        @employeeSearchJob = $("#employeeSearchJob")
        @employeeRowsCurrent = $("#employeeRowsCurrent")
        @employeePageCurrent = $("#employeePageCurrent")
        @employeeSearchJobSubmit = $("#employeeSearchJobSubmit")
        @employeeTotalRows = $("#employeeTotalRows")
        @employeePageTotal = $("#employeePageTotal")

        @isFormValid = false

        @utilitiesModal = new UtilitiesModal()
        @notify = new Notification()
        @renderEmployerJobTableContent = new RenderEmployerJobTable()
        @renderEmployeeJobTableContent = new RenderEmployeeJobTable()
        @overlay = new Loading()
        @event()

    event: ->
        @userID.val($.cookie("id"))
        @userRole.val($.cookie('role'))

        @setTotalRowsPage(@userRole.val())
        switch @userRole.val()
            when "employer"
                @employerButtonClickMechanism()
                
            when "employee"
                @employeeButtonClickMechanism()

        $(".showDeleteJobModal").on 'click', ((e) ->
            @deleteJobID.val($(e.currentTarget).data("job-id"))
            @utilitiesModal.setDeleteJobModal()
            @utilitiesForm.attr("action", "#{env.BASE_URL}Job/Delete.php").attr("data-form-type", "employeeDeleteForm")
        ).bind(@)

        @utilitiesForm.on "submit", ((e) ->
            e.preventDefault()
            @btnAddJobSubmit.html(@loadSpinner()).attr("disabled", true)
            switch(@utilitiesForm.data("form-type"))
                when "employerAddForm"
                    if(@isFormValid)
                        @utilitiesForm.unbind('submit').submit()

                when "employerUpdateForm"
                    @setupUpdateFormInputBeforeSubmit()
                    if(@isFormValid)
                        @utilitiesForm.unbind('submit').submit()

                when "employerDeleteForm"
                    @utilitiesForm.unbind('submit').submit()

                when "employeeDeleteForm"
                    @utilitiesForm.unbind('submit').submit()
        ).bind(@)
        return

    employeeButtonClickMechanism: ->
        $(".showViewJobModal").on "click", ((e) ->
            @viewJobID.val(e.currentTarget.getAttribute("data-job-id"))
            @utilitiesModal.setViewJobModal()
            @utilitiesForm.attr("action", "").attr("data-form-type", "employeeViewForm")
            @employeeViewJob(e.currentTarget.getAttribute("data-job-id"))
        ).bind(@)

        @employeeRowsCurrent.on "change", ((e) ->
            @employeePagination(@employeePageCurrent.val(), @employeeRowsCurrent.val())
            @employeePageCurrent.val(1)
        ).bind(@)

        @employeePageCurrent.on "focusout", ((e) ->
            @employeePagination(@employeePageCurrent.val(), @employeeRowsCurrent.val())
        ).bind(@)

        @employeeSearchJobSubmit.on "click", ((e) ->
            if @employeeSearchJob.val()
                @employeeJobSearch(@employeeSearchJob.val())
            else
                @setTotalRowsPage($.cookie('role'))
                @employeePagination(1, @employeeRowsCurrent.val())
        ).bind(@)

    employerButtonClickMechanism: ->
        @employerRowsCurrent.on "change", ((e) ->
            @employerPagination(@employerPageCurrent.val(), @employerRowsCurrent.val())
            @employerPageCurrent.val(1)
        ).bind(@)

        @employerPageCurrent.on "focusout", ((e) ->
            @employerPagination(@employerPageCurrent.val(), @employerRowsCurrent.val())
        ).bind(@)

        @employerSearchJobSubmit.on "click", ((e) ->
            if @employerSearchJob.val()
                @employerJobSearch(@employerSearchJob.val())
            else
                @setTotalRowsPage($.cookie('role'))
                @employerPagination(1, @employerRowsCurrent.val())
        ).bind(@)

        @btnShowAddJobModal.on 'click', ((e) ->
            @utilitiesModal.setAddJobModal()
            @addJobFormValidation()
            @utilitiesForm.attr("action", "#{env.BASE_URL}Job/Add.php").attr("data-form-type", "employerAddForm")

        ).bind(@)

        $(".showUpdateJobModal").on 'click', ((e) ->
            @utilitiesModal.setUpdateJobModal()
            @updateJobID.val($(e.currentTarget).data("job-id"))
            @prefillUpdateJobForm($(e.currentTarget).data("job-id"))
            @updateJobFormValidation()

            @utilitiesForm.attr("action", "#{env.BASE_URL}Job/Update.php").attr("data-form-type", "employerUpdateForm")
        ).bind(@)
        return

    employeeViewJob: (jobID) ->
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php",
            data: {
                getType: "getOne"
                jobID: jobID
            }
            success: ((response) ->
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        @jobDetailImage.attr("src", "#{env.BASE_URL}upload/#{callback.data.company.profile}").attr("alt", "#{callback.data.job.position} from #{callback.data.company.name}")
                        @jobDetailTitle.text(callback.data.job.position)
                        @jobDetailCompany.text(callback.data.company.name)
                        
                        @jobDetailExperience.text(callback.data.job.experience)
                        @jobDetailSalary.text(callback.data.job.salary)
                        @jobDetailDate.text((callback.data.job.postDate).split(" ")[0])
                        @jobDetailAddress.html("
                            #{callback.data.company.street}<br>
                            #{callback.data.company.postcode}, #{callback.data.company.city}, #{callback.data.company.state}
                        ")
                        @jobDescriptionContent.empty().html(callback.data.job.description)
                        @jobRequirementContent.empty().html(callback.data.job.requirement)
                        @jobDetailEmail.text("#{callback.data.company.email}").attr("href", "mailto:#{callback.data.company.email}")
                        @jobDetailURL.text("#{callback.data.company.url}").attr("href", "#{callback.data.company.url}")

                    when "failed"
                        @notify.showErrorMessage(callback.message)
                        window.location = "#notify"
                @overlay.closeLoadingOverlay()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        return


    setTotalRowsPage: (userRole) ->
        switch userRole
            when "employer"
                getType = "getAllJobCount"
                currentRows = @employerRowsCurrent.val()
            when "employee"
                getType = "getAllSavedJobCount"
                currentRows = @employeeRowsCurrent.val()

        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php",
            data: {
                getType: getType
                currentRows: currentRows
                user_id: $.cookie('id')
            }
            success: ((response) ->
                callback = JSON.parse(response)

                switch callback.status
                    when "success"
                        switch userRole
                            when "employer"
                                @employerTotalRows.empty().text(callback.data.totalRows)
                                @employerPageTotal.empty().text(callback.data.totalPage)
                            
                            when "employee"
                                @employeeTotalRows.empty().text(callback.data.totalRows)
                                @employeePageTotal.empty().text(callback.data.totalPage)
                    when "failed"
                        @notify.showErrorMessage(callback.message)
                        @overlay.closeLoadingOverlay()
                        window.location = "#notify"
            ).bind(@)
        })
        return

    employeeJobSearch: (input) ->
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php"
            data: {
                getType: "searchJobByEmployee",
                userID: $.cookie('id')
                searchTerm: input,
                currentRows: @employeeRowsCurrent.val()
            }
            success: ((response) ->
                
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        @tableRow.empty().html(@renderEmployeeJobTableContent.setRows(callback.data))
                        @employeePageCurrent.val(1)
                        @employeeTotalRows.empty().text(callback.totalRows)
                        @employeePageTotal.empty().text(callback.totalPage)

                    when "failed"
                        @tableRow.empty().html(@renderEmployeeJobTableContent.renderNoDataRow())
                        @employeeTotalRows.empty().text("0")
                        @employeePageTotal.empty().text(callback.totalPage)
                $(".showViewJobModal").on "click", ((e) ->
                    @viewJobID.val(e.currentTarget.getAttribute("data-job-id"))
                    @utilitiesModal.setViewJobModal()
                    @utilitiesForm.attr("action", "").attr("data-form-type", "employeeViewForm")
                    @employeeViewJob(e.currentTarget.getAttribute("data-job-id"))
                ).bind(@)
                @overlay.closeLoadingOverlay()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        return

    employeePagination: (page, row) ->
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php"
            data: {
                getType: "paginateEmployee",
                userID: $.cookie('id')
                page: page
                row: row
                totalRow: parseInt(@employeeTotalRows.text())
            }
            success: ((response) ->
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        @tableRow.empty().html(@renderEmployeeJobTableContent.setRows(callback.data))
                        @employeePageTotal.empty().text(callback.totalPage)
                        @employeeSearchJob.val("")

                    when "failed"
                        @tableRow.empty().html(@renderEmployeeJobTableContent.renderNoDataRow())
                $(".showViewJobModal").on "click", ((e) ->
                    @viewJobID.val(e.currentTarget.getAttribute("data-job-id"))
                    @utilitiesModal.setViewJobModal()
                    @utilitiesForm.attr("action", "").attr("data-form-type", "employeeViewForm")
                    @employeeViewJob(e.currentTarget.getAttribute("data-job-id"))
                ).bind(@)
                @overlay.closeLoadingOverlay()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        return

    employerJobSearch: (input) ->
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php"
            data: {
                getType: "searchJobByEmployer",
                userID: $.cookie('id')
                searchTerm: input,
                currentRows: @employerRowsCurrent.val()
            }
            success: ((response) ->
                
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        @tableRow.empty().html(@renderEmployerJobTableContent.setRows(callback.data))
                        @employerPageCurrent.val(1)
                        @employerPageTotal.empty().text(callback.totalPage)
                        @employerTotalRows.empty().text(callback.totalRows)

                    when "failed"
                        @tableRow.empty().html(@renderEmployerJobTableContent.renderNoDataRow())
                        @employerTotalRows.empty().text("0")
                        @employerPageTotal.empty().text("0")
                
                @overlay.closeLoadingOverlay()
                @employerButtonClickMechanism()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        return

    employerPagination: (page, row) ->
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php"
            data: {
                getType: "paginateEmployer",
                userID: $.cookie('id')
                page: page
                row: row
                totalRow: parseInt(@employerTotalRows.text())
            }
            success: ((response) ->

                callback = JSON.parse(response)
                
                switch callback.status
                    when "success"
                        @tableRow.empty().html(@renderEmployerJobTableContent.setRows(callback.data))
                        @employerPageTotal.empty().text(callback.totalPage)
                        @employeeSearchJob.val("")

                    when "failed"
                        @tableRow.empty().html(@renderEmployerJobTableContent.renderNoDataRow())
                @employerButtonClickMechanism()
                @overlay.closeLoadingOverlay()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        return

    setupUpdateFormInputBeforeSubmit: ->
        if(@updateJobPosition.val() is "") then @updateJobPosition.val(@updateJobPosition.data("position"))
        if(@updateJobSalary.val() is "") then @updateJobSalary.val(@updateJobSalary.data("salary"))
        if(@updateJobExperience.val() is "") then @updateJobExperience.val(@updateJobExperience.data("experience"))
        if(@updateJobDescription.val() is "") then @updateJobDescription.val(@updateJobDescription.data("description"))
        if(@updateJobRequirement.val() is "") then @updateJobRequirement.val(@updateJobRequirement.data("requirement"))
        return

    prefillUpdateJobForm: (jobID) ->
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php",
            data: {
                getType: "getOneByEmployer",
                jobID: jobID
            }
            success: ((response) ->
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        @updateJobPosition.attr("data-position", callback.data.position).attr("placeholder", callback.data.position)
                        @updateJobSalary.attr("data-salary", callback.data.salary).attr("placeholder", callback.data.salary)
                        @updateJobExperience.attr("data-experience", callback.data.experience).attr("placeholder", callback.data.experience)
                        @updateJobDescription.attr("data-description", callback.data.description).attr("placeholder", callback.data.description)
                        @updateJobRequirement.attr("data-requirement", callback.data.requirement).attr("placeholder", callback.data.requirement)
                    when "failed"
                        @notify.showErrorMessage(callback.message)
                        @overlay.closeLoadingOverlay()
                        window.location = "#notify"
                @overlay.closeLoadingOverlay()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        return


    addJobFormValidation: ->
        isPositionValid = false
        isSalaryValid = false
        isExperienceValid = false
        isDescriptionValid = false
        isRequirementValid = false

        @addJobPosition.on "focusout", (->
            if(@addJobPosition.val())
                @validFeedback(@addJobPosition, @addJobPositionValidate, "Looks Good")
                isPositionValid = true
            else
                @invalidFeedback(@addJobPosition, @addJobPositionValidate, "This is require field")
                isPositionValid = false
            @validateForm('add', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @addJobSalary.on "focusout", (->
            if(@addJobSalary.val())
                if(parseFloat(@addJobSalary.val()) > 300.0)
                    @validFeedback(@addJobSalary, @addJobSalaryValidate, "Looks Good")
                    isSalaryValid = true
                    @addJobSalary.val(parseFloat(@addJobSalary.val()).toFixed(2))
                else
                    @invalidFeedback(@addJobSalary, @addJobSalaryValidate, "Salary offered is too low")
                    isSalaryValid = false
            else
                @invalidFeedback(@addJobSalary, @addJobSalaryValidate, "This is require field")
                isSalaryValid = false
            @validateForm('add', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @addJobExperience.on "focusout", (->
            if(@addJobExperience.val())
                if(parseInt(@addJobExperience.val()) >= 0)
                    @validFeedback(@addJobExperience, @addJobExperienceValidate, "Looks Good")
                    isExperienceValid = true
                else
                    @invalidFeedback(@addJobExperience, @addJobExperienceValidate, "Minimal experience require is 1 year")
                    isExperienceValid = false
            else
                @invalidFeedback(@addJobExperience, @addJobExperienceValidate, "This is require field")
                isExperienceValid = false
            @validateForm('add', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @addJobDescription.on "focusout", (->
        
            if(@addJobDescription.val())
                @validFeedback(@addJobDescription, @addJobDescriptionValidate, "Looks Good")
                isDescriptionValid = true
            else
                @invalidFeedback(@addJobDescription, @addJobDescriptionValidate, "This is require field")
                isDescriptionValid = false
            @validateForm('add', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @addJobRequirement.on "focusout", (->
            if(@addJobRequirement.val())
                @validFeedback(@addJobRequirement, @addJobRequirementValidate, "Looks Good")
                isRequirementValid = true
            else
                @invalidFeedback(@addJobRequirement, @addJobRequirementValidate, "This is require field")
                isRequirementValid = false
            @validateForm('add', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)


    updateJobFormValidation: ->
        isPositionValid = false
        isSalaryValid = false
        isExperienceValid = false
        isDescriptionValid = false
        isRequirementValid = false

        @updateJobPosition.on "focusout", (->
            if(@updateJobPosition.val())
                @validFeedback(@updateJobPosition, @updateJobPositionValidate, "Looks Good")
                isPositionValid = true
            else
                @removeFeedback(@updateJobPosition, @updateJobPositionValidate)
                isPositionValid = false
            @validateForm('update', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @updateJobSalary.on "focusout", (->
            if(@updateJobSalary.val())
                if(parseInt(@updateJobSalary.val()) >= 1)
                    @validFeedback(@updateJobSalary, @addJobSalaryValidate, "Looks Good")
                    isSalaryValid = true
                else
                    @invalidFeedback(@updateJobSalary, @addJobSalaryValidate, "Salary offered is too low")
                    isSalaryValid = false
            else
                @removeFeedback(@updateJobSalary, @updateJobSalaryValidate)
                isSalaryValid = false
            @validateForm('update', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @updateJobExperience.on "focusout", (->
            if(@updateJobExperience.val())
                if(parseInt(@updateJobExperience.val()) >= 0)
                    @validFeedback(@updateJobExperience, @updateJobExperienceValidate, "Looks Good")
                    isExperienceValid = true
                else
                    @invalidFeedback(@updateJobExperience, @updateJobExperienceValidate, "Minimal experience require is 1 year")
                    isExperienceValid = false
            else
                @removeFeedback(@updateJobExperience, @updateJobExperienceValidate)
                isExperienceValid = false
            @validateForm('update', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @updateJobDescription.on "focusout", (->
            if(@updateJobDescription.val())
                @validFeedback(@updateJobDescription, @updateJobDescriptionValidate, "Looks Good")
                isExperienceValid = true
            else
                @removeFeedback(@updateJobDescription, @updateJobDescriptionValidate)
                isExperienceValid = false
            @validateForm('update', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)

        @updateJobRequirement.on "focusout", (->
            if(@updateJobRequirement.val())
                @validFeedback(@updateJobRequirement, @updateJobRequirementValidate, "Looks Good")
                isRequirementValid = true
            else
                @removeFeedback(@updateJobRequirement, @updateJobRequirementValidate)
                isRequirementValid = false
            @validateForm('update', {
                isPositionValid: isPositionValid,
                isSalaryValid: isSalaryValid,
                isExperienceValid: isExperienceValid,
                isDescriptionValid: isDescriptionValid,
                isRequirementValid: isRequirementValid
            })
        ).bind(@)


    validateForm: (type, inputValidate) ->
        switch type
            when "add"
                if(
                    inputValidate.isPositionValid is true and
                    inputValidate.isSalaryValid is true and
                    inputValidate.isExperienceValid is true and
                    inputValidate.isDescriptionValid is true and
                    inputValidate.isRequirementValid is true
                )
                    @isFormValid = true
                    @btnAddJobSubmit.attr("disabled", false)
                else
                    @isFormValid = false
                    @btnAddJobSubmit.attr("disabled", true)
                

            when "update"
                if(
                    inputValidate.isPositionValid is true or
                    inputValidate.isSalaryValid is true or
                    inputValidate.isExperienceValid is true or
                    inputValidate.isDescriptionValid is true or
                    inputValidate.isRequirementValid is true
                )
                    @isFormValid = true
                    @btnUpdateJobSubmit.attr("disabled", false)
                else
                    @isFormValid = false
                    @btnUpdateJobSubmit.attr("disabled", true)

    removeFeedback: (inputTag, notificationTag) ->
        inputTag.attr('title', '')
        inputTag.removeClass('is-invalid').removeClass('is-valid')
        notificationTag.removeClass('invalid-feedback').removeClass('valid-feedback').empty()
        return

    validFeedback: (inputTag, notificationTag, title) ->
        inputTag.attr('title', title)
        inputTag.removeClass('is-invalid').addClass('is-valid')
        notificationTag.removeClass('invalid-feedback').addClass('valid-feedback').text(title)
        return

    invalidFeedback: (inputTag, notificationTag, title) ->
        inputTag.attr('title', title)
        inputTag.removeClass('is-valid').addClass('is-invalid')
        notificationTag.removeClass('valid-feedback').addClass('invalid-feedback').text(title)
        return

    loadSpinner: ->
        return '
            <div class="spinner-border" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        '

export default JobManagement