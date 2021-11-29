import $ from "jquery"
import "jquery.cookie"

import env from "./config/env.coffee"

class CompanyProfile
    constructor: ->
        @states = [
            'johor',
            'kuala-lumpur'
            'pahang',
            'melaka',
            'selangor',
            'negeri-sembilan',
            'kedah',
            'perak',
            'terrengganu',
            'kelantan',
            'pulau-pinang',
            'perlis',
            'sabah',
            'sarawak'
        ]

    loadStateOptions: (state) ->
        return "
            <option class='text-capitalize' value='#{state}'>#{state.replace(/-/g, ' ')}</option>
        "

    renderUpdateCompanyForm: ->
        return "
            <form id='updateCompanyProfileForm' class='mt-4 profileForm--width' method='post' action='#{env.BASE_URL}Company/AddOrUpdate.php' enctype='multipart/form-data'>
                <input hidden name='user_id' value='#{$.cookie('id')}' />
                <input type='hidden' name='postType' value='#{if window.location.hash is '#addCompany' then 'add' else 'update'}' />
                <input type='hidden' name='companyProfileUpdate' id='companyProfileImageForUpdate' />
                <div class='form-group'>
                    <label for='updateCompanyProfileImage'>Company Profile Image</label>
                    <div class='profileForm__previewImage'>
                        <img id='companyPreviewImage' src='./images/placeholder.jpg' class='rounded' />
                    </div>
                    <input class='mt-2' name='companyProfile' id='updateCompanyProfileImage' type='file' accept='image/png, image/jpeg' />
                </div>
                <div class='form-group'>
                    <label for='updateCompanyName'>Company Name</label>
                    <input type='text' name='companyName' id='updateCompanyName' class='form-control' >
                    <div id='updateCompanyNameValidation'></div>
                </div>
                <div class='form-group'>
                    <label for='updateCompanyEmail'>Company Email</label>
                    <input type='email' name='companyEmail' id='updateCompanyEmail' class='form-control' >
                    <div id='updateCompanyEmailValidation'></div>
                </div>
                <div class='form-group'>
                    <label for='updateCompanyPhone'>Company Phone Number</label>
                    <input type='tel' name='companyPhone' id='updateCompanyPhone' class='form-control' >
                    <div id='updateCompanyPhoneValidation'></div>
                </div>
                <div class='form-group'>
                    <p>Company Address</p>
                    <div class='row'>
                        <div class='col-12'>
                            <label for='updateCompanyStreet'>Street</label>
                            <input type='text' name='companyStreet' id='updateCompanyStreet' class='form-control' >
                            <div id='updateCompanyStreetValidation'></div>
                        </div>
                    </div>
                    <div class='row mt-2'>
                        <div class='col-12 col-md-4'>
                            <label for='updateCompanyPostcode'>Postcode</label>
                            <input type='text' name='companyPostcode' id='updateCompanyPostcode' class='form-control' >
                            <div id='updateCompanyPostcodeValidation'></div>
                        </div>
                        <div class='col-12 col-md-4'>
                            <label for='updateCompanyCity'>City</label>
                            <input type='text' name='companyCity' id='updateCompanyCity' class='form-control' >
                            <div id='updateCompanyCityValidation'></div>
                        </div>
                        <div class='col-12 col-md-4'>
                            <label for='updateCompanyState'>State</label>
                            <select name='companyState' id='updateCompanyState' class='browser-default custom-select text-capitalize' >
                                <option class='text-capitalize' selected disabled>Select State</option>
                                #{
                                    for state in @states
                                        @loadStateOptions(state)
                                }
                            </select>
                            <div id='updateCompanyStateValidation'></div>
                        </div>
                    </div>
                </div>
                <div class='form-group'>
                    <label for='updateCompanyUrl'>Company URL</label>
                    <input type='text' name='companyUrl' id='updateCompanyUrl' class='form-control' >
                    <div id='updateCompanyUrlValidation'></div>
                </div>
                <div class='d-flex flex-column'>
                    <button class='btn btn-primary m-0 mt-3 w-100' type='submit' disabled
                        id='updateCompanyProfileFormSubmit'>
                        #{if window.location.hash is "#addCompany" then "Add" else "Update"}
                    </button>
                </div>
            </form>
        "

export default CompanyProfile