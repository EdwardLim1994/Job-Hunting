import $ from "jquery"

class JobListDrawer
    constructor: ->
        @jobListDrawerTrigger = $("#jobListDrawerTrigger")
        @jobListWrapper = $("#jobListWrapper")
        @jobDescriptionWrapper = $("#jobDescriptionWrapper")

        @event()

    event: ->
        @jobListDrawerTrigger.on "click", (->
            switch @jobListWrapper.data("state")
                when "isClose"
                    @openDrawer()
                when "isOpen"
                    @closeDrawer()
        ).bind(@)

    openDrawer: ->
        @jobListWrapper.attr("data-state", "isOpen").data("state", "isOpen").addClass("jobDrawer--isOpen").removeClass("jobDrawer--isClose")
        @jobDescriptionWrapper.css("overflow", "initial")
        @jobListDrawerTrigger.children().addClass("jobDrawer__menuIcon--isOpen").removeClass("jobDrawer__menuIcon--isClose")

    closeDrawer: ->
        @jobListWrapper.attr("data-state", "isClose").data("state", "isClose").addClass("jobDrawer--isClose").removeClass("jobDrawer--isOpen")
        @jobDescriptionWrapper.css("overflow", "auto")
        @jobListDrawerTrigger.children().addClass("jobDrawer__menuIcon--isClose").removeClass("jobDrawer__menuIcon--isOpen")

export default JobListDrawer