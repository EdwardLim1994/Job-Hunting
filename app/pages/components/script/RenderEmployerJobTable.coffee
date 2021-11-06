import $ from "jquery"
import "jquery.cookie"
import axios from "axios"
import JobManagement from './JobManagement.coffee'
import Loading from "./utilities/Loading.coffee"
import UtilitiesModal from "./UtilitiesModal.coffee"

import env from "./config/env.coffee"

class RenderEmployerJobTable
    constructor: ->
        @tableEmployerJob = $("#tableEmployerJob")
        @overlay = new Loading()
        @notify = new UtilitiesModal()

    renderTableUtilities: ->
        return "
            <div id='employerTableUtilitiesContainer'>
                <div class='row '>
                    <div class='col-6'>
                        <button class='btn btn-primary my-3 rounded mx-0' id='showAddJobModal' data-toggle='modal' data-target='#utilitiesModal'>Add Job</button>
                    </div>
                    <div class='col-6 justify-content-end' id='employerTableUtilitiesTotalRow'>
                        <h5 class='py-4'><strong>Total : </strong><span class='rowTotal' id='employerTotalRows'></span> rows</h5>
                    </div>
                </div>
                <div class='row mb-4' id='employerTableUtilities'>
                    <div class='col-12 col-md-6 pb-3 pb-md-0'>
                        <div class='input-group w-100'>
                            <input class='form-control' type='text' id='employerSearchJob' placeholder='Search'>
                            <div class='input-group-append'>
                                <span class='input-group-text btn-primary waves-effect' id='employerSearchJobSubmit'>
                                    <i class='fas fa-search text-white'aria-hidden='true'></i>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class='col-12 col-md-3'>
                        <div class='input-group pl-md-5 my-2 my-md-0 d-flex flex-row w-100 justify-content-md-center justify-content-end'>
                            <div class='input-group-prepend input__elements--textWidth'>
                                <span class='input-group-text w-100'><strong>Row : </strong></span>
                            </div>
                            <select class='browser-default custom-select' id='employerRowsCurrent'>
                                <option value='10' selected>10</option>
                                <option value='20'>20</option>
                                <option value='30'>30</option>
                                <option value='40'>40</option>
                            </select>
                        </div>
                    </div>
                    <div class='col-12 col-md-3'>
                        <div class='input-group d-flex my-2 my-md-0 flex-row w-100 justify-content-center'>
                            <div class='input-group-prepend input__elements--textWidth'>
                                <span class='input-group-text w-100'><strong>Page : </strong></span>
                            </div>
                            <input class='form-control w-25 input--disableSpinner' type='number' value='1' min='1' id='employerPageCurrent'/>
                            <div class='input-group-append'>
                                <span class='input-group-text'>
                                    of
                                </span>
                                <span class='input-group-text' id='employerPageTotal'></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        "

    renderTable: ->
        return "
            <div class='table-responsive'>
                <table class='table table-hover text-center tableReset'>
                    <thead class='grey white-text'>
                        <tr>
                            <th scope='col' class='th-sm'>ID</th>
                            <th scope='col' class='th-lg' >Position</th>
                            <th scope='col'>Experience (Year)</th>
                            <th scope='col'>Salary (RM)</th>
                            <th scope='col'>Posted Date</th>
                            <th scope='col'>Action</th>
                        </tr>
                    </thead>
                    <tbody id='tableRow'>
                        #{@renderRows()}
                    </tbody>
                </table>
            </div>
        "

    renderRows: ->
        html = ""
        @overlay.openLoadingOverlay()
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php",
            data: {
                getType: "getAllByEmployer",
                user_id: $.cookie('id')
                currentRows: 10
            }
            success: ((response) ->
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        html = @setRows(callback.data)
                        $("#employerTableUtilities, #employerTableUtilitiesTotalRow").removeClass('d-none').addClass('d-flex')
                    when "failed"
                        html = @renderNoDataRow()
                        $("#employerTableUtilities, #employerTableUtilitiesTotalRow").removeClass('d-flex').addClass('d-none')
                $("#tableRow").html(html)
                jobManagement = new JobManagement()
                @overlay.closeLoadingOverlay()
            ).bind(@)
            error: ((e) ->
                @notify.showErrorMessage(e.responseText)
                @overlay.closeLoadingOverlay()
                window.location = "#notify"
            ).bind(@)
        })
        
        return html

    setRows: (data) ->
        html = ""
        for item, i in data
            html += "
                <tr>
                    <th class='align-middle index' scope='row'>#{++i}</th>
                    <td class='align-middle'>#{item.position}</td>
                    <td class='align-middle'>#{item.experience}</td>
                    <td class='align-middle'>#{parseFloat(item.salary).toFixed(2)}</td>
                    <td class='align-middle'>#{item.postDate}</td>
                    <td class='align-middle'>
                        <button class='btn btn-info showUpdateJobModal' data-job-id='#{item.id}' data-toggle='modal' data-target='#utilitiesModal'>
                            <i class='fas fa-edit'></i>
                        </button>
                        <button class='btn btn-danger showDeleteJobModal' data-job-id='#{item.id}' data-toggle='modal' data-target='#utilitiesModal'>
                            <i class='fas fa-trash-alt'></i>
                        </button>
                    </td>
                </tr>
            "

        return html

    
    renderNoDataRow: ->
        return "
            <tr>
                <td colspan='6' class='text-center'>
                    <h5>No Data Found</h5>
                </td>
            </tr>
        "

    renderActionCol: (id) ->


export default RenderEmployerJobTable