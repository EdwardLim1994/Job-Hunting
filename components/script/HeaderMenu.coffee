import $ from "jquery"
import "jquery.cookie"

import env from "./config/env.coffee"

class HeaderMenu
    constructor: ->
        @headerMenu = $("#headerMenu")
        @isLogin = if $.cookie('id') then true else false
        @event()
        return

    event: ->
        @getLoginStatus()
        return

    getLoginStatus: ->
        if(@isLogin)
            @headerMenu.html("
                <ul class='navbar-nav mr-0 ml-auto d-flex justify-content-center justify-content-md-end flex-row'>
                    <li class='nav-item'>
                        <a class='nav-link px-3 rounded text-white' href='#{env.CURRENT_PATH}/profile.html'>My Profile</a>
                    </li>
                    <li class='nav-item'>
                        <a class='nav-link px-3 rounded text-white' id='triggerLogout'>Logout</a>
                    </li>
                </ul>
            ")
        else
            @headerMenu.html("
                <ul class='navbar-nav mr-0 ml-auto'>
                    <li class='nav-item d-flex justify-content-center justify-content-md-end '>
                        <a class='nav-link text-white px-3 rounded' id='triggerLoginRegister' data-toggle='modal' data-target='#loginRegisterModal'>Login/Register</a>
                    </li>
                </ul>
            ")

export default HeaderMenu