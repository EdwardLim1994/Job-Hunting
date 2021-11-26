import $ from "jquery"

import axios from "axios"

import env from "./config/env.coffee"

import UtilitiesModal from "./UtilitiesModal.coffee"
import Loading from "./utilities/Loading.coffee"

class RenderJobList

    constructor: ->
        @jobList = $("#jobList")
        @jobListContainer = $("#jobListContainer")
        @scrollToTopBtn = $("#scrollToTopBtn")

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

        @searchJobInput = $("#searchJobInput")

        @notify = new UtilitiesModal()
        @overlay = new Loading()
        
        @event()

    stopScrolling: (e) ->
        e.preventDefault()
        e.stopPropagation()
        return false

    event: ->
        @renderList()
        @scrollToTopBtn.on "click", (->
            @jobList.animate({ scrollTop: 0 }, 600, 'swing')
            @scrollToTopBtn.toggleClass("d-none", 400)
        ).bind(@)
        @jobList.scroll(((e) ->

            isTriggered = false
            containerHeight = 0
            switch $('body').data("state")
                when "mobile"
                    containerHeight = 552
                when "desktop"
                    containerHeight = 275

            if @jobList.scrollTop() >= containerHeight
                @scrollToTopBtn.removeClass("d-none").addClass("d-block")
            else
                @scrollToTopBtn.addClass("d-none").removeClass("d-block")

            if Math.ceil(@jobList.scrollTop()) >= Math.floor(@jobList.prop('scrollHeight') - @jobList.outerHeight())
                isTriggered = true
                @jobListContainer.attr("data-is-loading", 1)
                @jobListContainer.data("is-loading", 1)
            else
                isTriggered = false
                @jobListContainer.attr("data-is-loading", 0)
                @jobListContainer.data("is-loading", 0)

            
            if(isTriggered and parseInt(@jobListContainer.data("is-loading")) and not parseInt(@jobListContainer.data("is-end")))
                if(not parseInt(@jobListContainer.data("is-rendering")))
                    @renderList()
                    isTriggered = false
                    @jobListContainer.attr("data-is-loading", 0)
                    @jobListContainer.data("is-loading", 0)
                    @jobListContainer.attr("data-is-rendering", 1)
                    @jobListContainer.data("is-rendering", 1)
                return

        ).bind(@))

        doneTypingInterval = 2000
        typingTimer = null
        @searchJobInput.on "keyup", (->
            clearTimeout(typingTimer)

            if(@searchJobInput.val())
                @jobListContainer.data("is-searching", 1).attr("data-is-searching", 1)
                @jobListContainer.data("current-offset", 0).attr("data-current-offset", 0)
                @jobListContainer.empty().html("
                    <div class='d-flex justify-content-center py-3 w-80 h-100'>
                        <div class='spinner-border fast p-0 m-0' role='status'>
                            <span class='sr-only'>Loading...</span>
                        </div>
                    </div>
                ")
                typingTimer = setTimeout((->
                    @jobListContainer.empty()
                    @jobListContainer.attr("data-is-end", 0)
                    @jobListContainer.data("is-end", 0)
                    @renderList()
                ).bind(@), doneTypingInterval)
            else
                @jobListContainer.data("is-searching", 0).attr("data-is-searching", 0)
                @jobListContainer.data("current-offset", 0).attr("data-current-offset", 0)
                @jobListContainer.empty()
                @jobListContainer.attr("data-is-end", 0)
                @jobListContainer.data("is-end", 0)
                @renderList()
        ).bind(@)
        @searchJobInput.on "keydown", (->
            clearTimeout(typingTimer)
        ).bind(@)

    renderList: ->
        if not parseInt(@jobListContainer.data("is-end"))
            @overlay.openLoadingOverlay()

        offset = @jobListContainer.data("current-offset")
        $.ajax({
            method: "POST"
            url: "#{env.BASE_URL}Job/Get.php"
            data: {
                getType: if @searchJobInput.val() then "getSearch" else "getAll"
                offset: offset
                limit: 10
                searchTerm: @searchJobInput.val()
            }
            success: ((response) ->
                html = ""
                callback = JSON.parse(response)
                current_offset = @jobListContainer.data('current-offset')
                firstJobID = 0
                
                if((callback.data).length > 0)
                    $.each(callback.data, (i, item) ->
                        date = (item.postDate).split(" ")

                        if firstJobID is 0 then firstJobID = item.id
                        html += "
                            <a class='row p-0 m-0 jobShowcase__options border' data-job-id='#{item.id}'>
                                <div class='col-4 p-0 m-0 p-3 d-flex justify-content-center align-items-center'>
                                    <img src='#{env.BASE_URL}upload/#{item.profile}' alt='' class='img-fluid' />
                                </div>
                                <div class='col p-0 m-0 p-3'>
                                    <h2 class='h2 p-0 m-0'>#{item.position}</h2>
                                    <p class='p-0 m-0 pb-3'>
                                        <small class='text-muted'>#{item.company}</small>
                                    </p>
                                    <table>
                                        <tr>
                                            <td class='pr-2'>
                                                <p class='p-0 m-0'><strong>Experience : </strong></p>
                                            </td>
                                            <td>
                                                <p class='p-0 m-0'>#{item.experience} #{if parseInt(item.experience) > 1 then "years" else "year"}</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class='pr-2'>
                                                <p class='p-0 m-0'><strong>Salary : </strong></p>
                                            </td>
                                            <td>
                                                <p class='p-0 m-0'>RM #{parseFloat(item.salary).toFixed(2)}</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class='pr-2'>
                                                <p class='p-0 m-0'><strong>Posted Date : </strong></p>
                                            </td>
                                            <td>
                                                <p class='p-0 m-0'>#{date[0]}</p>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </a>
                        "
                    )
                    
                    @jobListContainer.data("current-offset", parseInt(offset) + 1).attr("data-current-offset", parseInt(offset) + 1)
                    @jobListContainer.append(html)
                    if @jobListContainer.children().length <= 10
                        @initialSelectJob(firstJobID)
                    @selectJob()
                    
                else if @searchJobInput.val()
                    @jobListContainer.append("
                        <div class='py-3 w-80 h-100 border'>
                            <h3 class='text-center'>Job not found</h3>
                        </div>
                    ")
                    @overlay.closeLoadingOverlay()

                else
                    @jobListContainer.attr("data-is-end", 1)
                    @jobListContainer.data("is-end", 1)
                    @jobListContainer.append("
                        <div class='py-3 w-80 h-100 border'>
                            <h5 class='text-center font-weight-bold'>End of List</h5>
                        </div>
                    ")
                    @overlay.closeLoadingOverlay()

                @jobListContainer.attr("data-is-rendering", 0)
                @jobListContainer.data("is-rendering", 0)
                

            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e)
                window.location = "#notify"
                return
            ).bind(@)
        })

    initialSelectJob: (jobID) ->
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php"
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
                        @jobDetailURL.text("#{if callback.data.company.url then callback.data.company.url else "no website"}").attr("href", "#{if callback.data.company.url then callback.data.company.url else ""}")
                        @jobListContainer.find(">:first-child").addClass('jobShowcase__options--active')
                        @jobListContainer.attr("data-current-selected", jobID)
                        @jobListContainer.data('current-selected', jobID)

                        if($.cookie('id') and $.cookie('role') is "employee")
                            response = await axios.post("#{env.BASE_URL}Job/Save.php", {
                                user_id: $.cookie('id'),
                                job_id: $("#jobListContainer").data("current-selected"),
                                option: 'get'
                            })
                            
                            callback = response.data
                            switch callback.status
                                when "success"
                                    @jobDetailSaved.html("
                                        <a id='jobDetailSavedBtn' class='py-3 px-2'>
                                            <i class='fas fa-bookmark fa-2x text-primary'></i>
                                        </a>
                                    ")
                                when "failed"
                                    @jobDetailSaved.html("
                                        <a id='jobDetailSavedBtn' class='py-3 px-2'>
                                            <i class='far fa-bookmark fa-2x '></i>
                                        </a>
                                    ")

                                when "error"
                                    @notify.showErrorMessage(e)
                                    window.location = "#notify"

                        else
                            @jobDetailSaved.empty()
                        
                        @saveJob()
                        
                    when "failed"
                        @notify.showErrorMessage(e)
                        window.location = "#notify"
                @overlay.closeLoadingOverlay()
            ).bind(@)
        })

    saveJob: ->
        $("#jobDetailSavedBtn").on "click", ((e) ->
            @overlay.openLoadingOverlay()
            if $(e.currentTarget).children().hasClass("far")
                response = await axios.post("#{env.BASE_URL}Job/Save.php", {
                    user_id: $.cookie('id'),
                    job_id: @jobListContainer.data("current-selected"),
                    option: 'save'
                })
                callback = response.data

                switch callback.status
                    when "success"
                        $(e.currentTarget).children().removeClass("far").addClass("fas text-primary")
                    when "failed"
                        @notify.showErrorMessage(e)
                        window.location = "#notify"

            else if $(e.currentTarget).children().hasClass("fas")
                response = await axios.post("#{env.BASE_URL}Job/Save.php", {
                        user_id: $.cookie('id'),
                        job_id: @jobListContainer.data("current-selected"),
                        option: 'unsave'
                    })

                callback = response.data

                switch callback.status
                    when "success"
                        $(e.currentTarget).children().removeClass("fas", "text-primary").addClass("far")
                    when "failed"
                        @notify.showErrorMessage(e)
                        window.location = "#notify"
            
            @overlay.closeLoadingOverlay()
        ).bind(@)

    selectJob: ->
        $(".jobShowcase__options").on "click", ((e) ->
            @overlay.openLoadingOverlay()
            jobID = e.currentTarget.getAttribute("data-job-id")
            $(e.currentTarget).addClass("jobShowcase__options--active")
            $.ajax({
                method: "POST",
                url: "#{env.BASE_URL}Job/Get.php"
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
                            
                            $("a[data-job-id=#{@jobListContainer.data('current-selected')}]").removeClass("jobShowcase__options--active")
                            @jobListContainer.attr("data-current-selected", jobID)
                            @jobListContainer.data('current-selected', jobID)

                            if(window.innerWidth <= 720)
                                jobListDrawerTrigger.children().addClass("jobDrawer__menuIcon--isClose").removeClass("jobDrawer__menuIcon--isOpen")
                                jobListWrapper.attr("data-state", "isClose").data("state", "isClose").addClass("jobDrawer--isClose").removeClass("jobDrawer--isOpen")

                            if($.cookie('id') and $.cookie('role') is "employee")
                                response = await axios.post("#{env.BASE_URL}Job/Save.php", {
                                    user_id: $.cookie('id'),
                                    job_id: @jobListContainer.data("current-selected"),
                                    option: 'get'
                                })

                                callback = response.data

                                switch callback.status
                                    when "success"
                                        @jobDetailSaved.empty().html("
                                            <a id='jobDetailSavedBtn' class='py-3 px-2'>
                                                <i class='fas fa-bookmark fa-2x text-primary'></i>
                                            </a>
                                        ")
                                    when "failed"
                                        @jobDetailSaved.empty().html("
                                            <a id='jobDetailSavedBtn' class='py-3 px-2'>
                                                <i class='far fa-bookmark fa-2x'></i>
                                            </a>
                                        ")

                                    when "error"
                                        @notify.showErrorMessage(e)
                                        window.location = "#notify"

                            @saveJob()
                            @overlay.closeLoadingOverlay()
                        when "failed"
                            @notify.showErrorMessage(e)
                            window.location = "#notify"
                            @overlay.closeLoadingOverlay()
                ).bind(@)
            })
        ).bind(@)

export default RenderJobList