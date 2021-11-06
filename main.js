//Import styles
import './style.styl';
import './node_modules/mdbootstrap/css/bootstrap.css';
import './node_modules/mdbootstrap/css/mdb.css';
import './node_modules/mdbootstrap/css/style.css';
import './node_modules/mdbootstrap/css/addons/datatables2.min.css';

//Import plugins
import $ from 'jquery';
import 'jquery.cookie';

//Import modules
import HeaderMenu from './components/script/HeaderMenu.coffee';
import UserAuthentication from './components/script/UserAuthentication.coffee';
import UpdateCompanyProfile from './components/script/UpdateCompanyProfile.coffee';
import Responsive from './components/script/utilities/Responsive.coffee';
import ProfileTab from './components/script/ProfileTab.coffee';

import RenderJobList from './components/script/RenderJobList.coffee';
import JobListDrawer from './components/script/JobListDrawer.coffee';

//Initiate modules
const headerMenu = new HeaderMenu();
const responsive = new Responsive();

if (window.location.pathname == '/profile.html') {
	const profileTab = new ProfileTab();
	const updateCompanyProfile = new UpdateCompanyProfile();
}

if (window.location.pathname == '/') {
	const renderJobList = new RenderJobList();
	const jobListDrawer = new JobListDrawer();

	if ($.cookie('role') == 'employer') {
		const updateCompanyProfile = new UpdateCompanyProfile();
	}
}

const userAuthentication = new UserAuthentication();

//Set latest year on copyright notice
$('#latestYear').text(new Date().getFullYear());
