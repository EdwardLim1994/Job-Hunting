import $ from 'jquery'

class Responsive
    constructor: ->
        @atSmall = 540
        @atMedium = 720
        @atLarge = 960
        @atExtraLarge = 1140

        @headerMenu = $("#headerMenu")

        @jobListWrapper = $("#jobListWrapper")
        @jobList = $("#jobList")
        @jobDetailContent = $("#jobDetailContent")
        @jobDescriptionWrapper = $("#jobDescriptionWrapper")
        @jobListWrapper = $("#jobListWrapper")
        @jobListDrawerTrigger = $("#jobListDrawerTrigger")
        @profileContent = $("#profileContent")

        @event()

    event: ->
        @changeHeaderMenuColor()

    changeHeaderMenuColor: ->
        if(window.innerWidth > @atMedium)
            $('body').attr("data-state", "desktop")
            $('body').data("state", "desktop")
            @headerMenu.removeClass('primary-color')
            @jobListWrapper.addClass("position-relative").removeClass("position-relative").css({ "width": "100%" })
            @jobList.css("max-height", "78vh")
            @jobDetailContent.css("max-height", "300px")
            @jobDescriptionWrapper.css("max-height", "auto").css("transform", "translateY(0)")
            @jobListDrawerTrigger.removeClass("d-block").addClass("d-none")
            @profileContent.css("transform", "translateY(0)")
        else
            $('body').attr("data-state", "mobile")
            $('body').data("state", "mobile")
            @headerMenu.addClass('primary-color')
            @jobListWrapper.removeClass("position-relative").addClass("position-absolute jobDrawer--isClose").css({ "width": "95%" })
            @jobList.css("max-height", "71.5vh")
            @jobDetailContent.css("max-height", "auto")
            @jobDescriptionWrapper.css("max-height", "70.5vh").css("transform", "translateY(0.5rem)")
            @jobListDrawerTrigger.removeClass("d-none").addClass("d-block").children().addClass("jobDrawer__menuIcon--isClose")
            #@profileContent.css("transform", "translateY(25px)")




export default Responsive