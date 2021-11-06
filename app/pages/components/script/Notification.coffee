import $ from "jquery"

class Notification
    constructor: ->
        @notifyHeader = $("#notificationTitle")
        @notifyBody = $("#notificationBody")
        @notifyFooter = $("#notificationFooter")
        @notifyType = $("#notificationType")

    showSuccessMessage: (body) ->
        @notifyHeader.empty().text('Success')
        @notifyBody.empty().html(@renderSuccessIcon())
        @notifyBody.append(body)
        @notifyFooter.find('button').removeClass('btn-danger').removeClass("btn-info").addClass("btn-success")
        @notifyType.removeClass("modal-danger").removeClass("modal-info").addClass("modal-success")
        window.location.hash = "notify"
        return

    showErrorMessage: (body) ->
        @notifyHeader.empty().text('Error')
        @notifyBody.empty().html(@renderErrorIcon())
        @notifyBody.append(body)
        @notifyFooter.find('button').removeClass('btn-success').removeClass("btn-info").addClass("btn-danger")
        @notifyType.removeClass("modal-success").removeClass("modal-info").addClass("modal-danger")
        window.location.hash = "notify"
        return

    showNormalMessage: (body) ->
        @notifyHeader.empty().text('Information')
        @notifyBody.empty().html(@renderNotifyIcon())
        @notifyBody.append(body)
        @notifyFooter.find('button').removeClass('btn-success').remove("btn-danger").addClass("btn-info")
        @notifyType.removeClass("modal-success").removeClass("modal-danger").addClass("modal-info")
        window.location.hash = "notify"
        return

    renderSuccessIcon: ->
        return '
            <i class="fas fa-check fa-4x mb-3 animated rotateIn"></i>
        '

    renderErrorIcon: ->
        return '
            <i class="fas fa-times fa-4x mb-3 animated rotateIn"></i>
        '

    renderNotifyIcon: ->
        return '
            <i class="fas fa-exclamation fa-4x mb-3 animated rotateIn"></i>
        '

export default Notification