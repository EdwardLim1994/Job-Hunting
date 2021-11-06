import $ from "jquery"
import "jquery.cookie"

import axios from "axios"

import JobManagement from './JobManagement.coffee'

import Loading from "./utilities/Loading.coffee"

import env from "./config/env.coffee"

class RenderEmployeeJobTable
    constructor: ->
        @tableEmployeeJob = $("#tableEmployeeJob")
        @overlay = new Loading()

    renderTableUtilities: ->
        return "
            <div id='employeeTableUtilitiesContainer'>
            <div class='row '>
                <div class='col-12 text-right'>
                    <h5 class='py-4'><strong>Total : </strong><span class='rowTotal' id='employeeTotalRows'></span> rows</h5>
                </div>
            </div>
            <div class='row mb-4'>
                <div class='col-12 col-md-6 pb-3 pb-md-0'>
                    <div class='input-group w-100'>
                        <input class='form-control' type='text' id='employeeSearchJob' placeholder='Search'>
                        <div class='input-group-append'>
                            <span class='input-group-text btn-primary waves-effect' id='employeeSearchJobSubmit'>
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
                        <select class='browser-default custom-select' id='employeeRowsCurrent'>
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
                        <input class='form-control w-25 input--disableSpinner' type='number' value='1' min='1' id='employeePageCurrent'/>
                        <div class='input-group-append'>
                            <span class='input-group-text'>
                                of
                            </span>
                            <span class='input-group-text' id='employeePageTotal'></span>
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
                            <th class='index' scope='col'>ID</th>
                            <th scope='col' class='wide'>Position</th>
                            <th scope='col'>Company</th>
                            <th scope='col'>Experience (Year)</th>
                            <th scope='col'>Salary (RM)</th>
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
        @overlay.openLoadingOverlay()
        html = ""
        $.ajax({
            method: "POST",
            url: "#{env.BASE_URL}Job/Get.php",
            data: {
                getType: "getAllByEmployee",
                user_id: $.cookie('id')
                currentRows: 10
            }
            success: ((response) ->
                callback = JSON.parse(response)
                switch callback.status
                    when "success"
                        html = @setRows(callback.data)
                        $("#employeeTableUtilitiesContainer").removeClass('d-none').addClass('d-block')
                    when "failed"
                        html = @renderNoDataRow()
                        $("#employeeTableUtilitiesContainer").removeClass('d-block').addClass('d-none')
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
                    <td class='align-middle wide'>
                        <div class='row'>
                            <div class='col-4 #{if window.innerWidth <= 720 then 'd-none' else ''}'>
                                <img class='img-fluid' src='#{env.BASE_URL}upload/#{item.company_profile}' alt='#{item.company_name}' />
                            </div>
                            <div class='col text-left my-auto'>
                                <h5 class='h5-responsive'>#{item.position}</h5>
                            </div>
                        </div>
                    </td>
                    <td class='align-middle'>
                        <a class='text-primary' href='#{if item.company_url then item.company_url else ''}'>
                            #{item.company_name}
                        </a>
                    </td>
                    <td class='align-middle'>#{item.experience}</td>
                    <td class='align-middle'>#{parseFloat(item.salary).toFixed(2)}</td>
                    <td class='align-middle justify-content-center'>
                        <button class='btn btn-info showViewJobModal' data-job-id='#{item.id}' data-toggle='modal' data-target='#utilitiesModal'>
                            <i class='fas fa-address-book'></i>
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



export default RenderEmployeeJobTable