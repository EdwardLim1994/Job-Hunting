# Import Plugins
import $ from 'jquery'

# Import Images
import "../images/placeholder.jpg"
import "../images/titleImage.jpeg"
import "../images/favicon/android-chrome-192x192.png"
import "../images/favicon/android-chrome-512x512.png"
import "../images/favicon/apple-touch-icon.png"
import "../images/favicon/favicon-16x16.png"
import "../images/favicon/favicon-32x32.png"
import "../images/favicon/favicon.ico"

# Import CSS or Stylus files
import './style.styl'

# Import JS or Coffeescript
import HeaderMenu from './components/script/HeaderMenu.coffee'
import UserAuthentication from './components/script/UserAuthentication.coffee'
import UpdateCompanyProfile from './components/script/UpdateCompanyProfile.coffee'
import Responsive from './components/script/utilities/Responsive.coffee'
import ProfileTab from './components/script/ProfileTab.coffee'
import RenderJobList from './components/script/RenderJobList.coffee'
import JobListDrawer from './components/script/JobListDrawer.coffee'

import env from "./components/script/config/env.coffee"

headerMenu = new HeaderMenu()
responsive = new Responsive()

if window.location.pathname is "#{env.CURRENT_PATH}/profile.html"
    profileTab = new ProfileTab()
    updateCompanyProfile = new UpdateCompanyProfile()

if window.location.pathname is "#{env.CURRENT_PATH}/"
    renderJobList = new RenderJobList()
    jobListDrawer = new JobListDrawer()

    if ($.cookie('role') is 'employer')
        updateCompanyProfile = new UpdateCompanyProfile()


userAuthentication = new UserAuthentication()

#Set latest year on copyright notice
$('#latestYear').text(new Date().getFullYear())
