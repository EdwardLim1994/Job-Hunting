import $ from "jquery"

class Loading
    constructor: ->
        @overlay = $("#overlay")

    openLoadingOverlay: ->
        @overlay.removeClass("d-none").addClass("d-flex")

    closeLoadingOverlay: ->
        @overlay.removeClass("d-flex").addClass("d-none")


export default Loading