class UpdateProfile
    constructor: ->

    renderUpdateForm: ->
        return "
            <form id='updateProfileForm' class='mt-4 profileForm--width'>
                <div class='form-group'>
                    <label for='updateName'>Your Name</label>
                    <input type='text' id='updateName' class='form-control' required>
                    <div id='updateNameValidation'></div>
                </div>
                <div class='form-group'>
                    <label for='updateEmail'>Your Email</label>
                    <input type='email' id='updateEmail' class='form-control' required>
                    <div id='updateEmailValidation'></div>
                </div>
                <div class='form-group'>
                    <label for='updateUsername'>Username</label>
                    <input type='text' id='updateUsername' class='form-control' required>
                    <div id='updateUsernameValidation'></div>
                </div>
                <div class='form-group'>
                    <label for='updatePassword'>Password</label>
                    <input type='password' id='updatePassword' class='form-control'required>
                    <div id='updatePasswordValidation'></div>
                </div>
                <div class='form-group'>
                    <label for='updateConfirmPassword'>Confirm Password</label>
                    <input type='password' id='updateConfirmPassword' class='form-control'
                        required>
                    <div id='updateConfirmPasswordValidation'></div>
                </div>
                <div class='d-flex flex-column'>
                    <button class='btn btn-primary m-0 mt-2 w-100' disabled type='button'
                        id='updateProfileFormSubmit'>
                        Update
                    </button>
                </div>
            </form>
        "


export default UpdateProfile