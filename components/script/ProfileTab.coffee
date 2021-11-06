import $ from "jquery"
import "jquery.cookie"

import UpdateProfile from "./UpdateProfile.coffee"
import UpdateCompanyProfile from "./CompanyProfile.coffee"
import RenderEmployerJobTable from "./RenderEmployerJobTable.coffee"
import RenderEmployeeJobTable from "./RenderEmployeeJobTable.coffee"

class ProfileTab
    constructor: ->
        @profileContent = $("#profileContent")
        @userRole = $.cookie('role')

        @updateProfileContent = new UpdateProfile()
        @updateCompanyProfileContent = new UpdateCompanyProfile()
        @renderEmployerJobTableContent = new RenderEmployerJobTable()
        @renderEmployeeJobTableContent = new RenderEmployeeJobTable()

        @profileTab = $("#updateProfile-tab")
        @savedJobTab = $("#savedJob-tab")
        @companyTab = $("#companyProfile-tab")
        @jobTab = $("#addJob-tab")

        @profileTitle = $("#profileTitle")

        @event()

    event: ->
        @setProfileTab()
        
    setProfileTab: ->

        switch(@userRole)
            when "employee"
                @profileContent.html(@setEmployeeProfileContent())
                return

            when "employer"
                @profileContent.html(@setEmployerProfileContent())
                return
            
        return


    setEmployeeProfileContent: ->
        return "
            <ul class='nav nav-tabs sticky-top bg-white pt-4' id='employeeTab' role='tablist'>
                <li class='nav-item'>
                    <a id='updateProfile-tab' class='nav-link active' data-toggle='tab' href='#updateProfile'
                        role='tab' aria-controls='updateProfile' aria-selected='true'
                        aria-expanded='true'>Profile</a>
                </li>
                <li class='nav-item'>
                    <a id='savedJob-tab' class='nav-link' data-toggle='tab' href='#savedJob' role='tab'
                        aria-controls='savedJob' aria-selected='false'>Saved Job</a>
                </li>
            </ul>
            <div class='tab-content' id='employeeContent'>
                <div class='tab-pane fade show active profileForm--addHeight' id='updateProfile' role='tabpanel'
                    aria-labelledby='updateProfile-tab'>
                    <div class='py-3'>
                        <h2 class='h2-responsive'>My Profile</h2>
                        #{@updateProfileContent.renderUpdateForm()}
                    </div>
                </div>
                <div class='tab-pane fade' id='savedJob' role='tabpanel' aria-labelledby='savedJob-tab'>
                    <div class='py-3'>
                        <h2 class='h2-responsive'>Saved Job</h2>
                        #{@renderEmployeeJobTableContent.renderTableUtilities()}
                        <div id='employeeTableContainer' class='py-3'>
                            #{@renderEmployeeJobTableContent.renderTable()}
                        </div>
                    </div>
                </div>
            </div>
        "

    setEmployerProfileContent: ->
        return "
            <ul class='nav nav-tabs sticky-top bg-white pt-4' id='employeeTab' role='tablist'>
                <li class='nav-item'>
                    <a id='updateProfile-tab' class='nav-link active' data-toggle='tab' href='#updateProfile'
                        role='tab' aria-controls='updateProfile' aria-selected='true'
                        aria-expanded='true'>Profile</a>
                </li>
                <li class='nav-item'>
                    <a id='companyProfile-tab' class='nav-link' data-toggle='tab' href='#companyProfile' role='tab'
                        aria-controls='companyProfile' aria-selected='false'>Company</a>
                </li>
                <li class='nav-item'>
                    <a id='addJob-tab' class='nav-link' data-toggle='tab' href='#addJob' role='tab'
                        aria-controls='addJob' aria-selected='false'>Job</a>
                </li>
            </ul>
            <div class='tab-content' id='employeeContent'>
                <div class='tab-pane fade show active profileForm--addHeight' id='updateProfile' role='tabpanel'
                    aria-labelledby='updateProfile-tab'>
                    <div class='py-3'>
                        <h2 class='h2-responsive'>My Profile</h2>
                        #{@updateProfileContent.renderUpdateForm()}
                    </div>
                </div>
                <div class='tab-pane fade profileForm--addMoreHeight' id='companyProfile' role='tabpanel' aria-labelledby='companyProfile-tab'>
                    <div class='py-3'>
                        <h2 class='h2-responsive'>Company Profile</h2>
                        #{@updateCompanyProfileContent.renderUpdateCompanyForm()}
                    </div>
                </div>
                <div class='tab-pane fade' id='addJob' role='tabpanel' aria-labelledby='addJob-tab'>
                    <div class='py-3'>
                        <h2 class='h2-responsive'>Job Management</h2>
                        #{@renderEmployerJobTableContent.renderTableUtilities()}
                        <div id='employerTableContainer' class='py-3'>
                            #{@renderEmployerJobTableContent.renderTable()}
                        </div>
                    </div>
            </div>
        "

export default ProfileTab