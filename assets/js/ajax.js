import store from './store';
import React from "react";

export function post(path, body) {
    let state = store.getState();
    let token = state.session ? state.session.token || "" : "";
    console.log("body",body)

    return fetch('/ajax' + path, {
        method: 'post',
        credentials: 'same-origin',
        headers: new Headers({
            'x-csrf-token': window.csrf_token,
            'content-type': "application/json; charset=UTF-8",
            'accept': 'application/json',
            'x-auth': token || "",
        }),
        body: JSON.stringify(body),
    }).then((resp) => resp.json());
}

export function get(path) {
    let state = store.getState();
    let token = state.session.token || "";
    let current_user = state.session ? state.session.user_id || null : null;

    return fetch('/ajax' + path, {
        method: 'get',
        credentials: 'same-origin',
        headers: new Headers({
            'x-csrf-token': window.csrf_token,
            'content-type': "application/json; charset=UTF-8",
            'accept': 'application/json',
            'x-auth': token || "",
        }),
        assigns: {current_user: "current_user"}
    }).then((resp) => resp.json());
}

export function approve_sheet(id){
    post('/approve', {id: id})
        .then((resp) => {
            console.log("resp",resp)
            store.dispatch({
                type: 'CHANGE_SHEET',
                data: [resp.data],
            });
        });
}

export function submit_login(form) {
    let state = store.getState();
    let data = state.forms.login;
    post('/sessions', data)
        .then((resp) => {
            console.log("resp",resp)
            if (resp.token) {
                localStorage.setItem('session', JSON.stringify(resp));
                store.dispatch({
                    type: 'LOG_IN',
                    data: resp,
                });
                form.redirect('/');
            }
            else {
                console.log("resp",resp)
                store.dispatch({
                    type: 'CHANGE_LOGIN',
                    data: {errors: JSON.stringify(resp.errors)},
                });
            }
        });
}

export function list_sheets() {
    get('/sheets')
        .then((resp) => {
            console.log("list_sheets", resp);
            store.dispatch({
                type: 'CHANGE_SHEET',
                data: resp.data,
            });
        });
}

export function list_jobs() {
    get('/jobs')
        .then((resp) => {
            console.log("list_jobs", resp);
            store.dispatch({
                type: 'ADD_JOBS',
                data: resp.data,
            });
        });
}

function format_form_data(data, user_id){
    let req = {
        user_id: user_id,
        workdate: data.workdate,
    }
    data.logs.forEach(function (log,index) {
        req["job_id_"+index] = log.job_id
        req["hours_"+index] = log.hours
        req["desc_"+index] = log.desc
    })
    return req;
}

function validate_hours(data, user_id){
    let total_hours = 0;
    let partial_rows = 0;
    data.logs.forEach(function (log,index) {
        total_hours += parseInt(log.hours)
        if(log.job_id == -1 || log.hours == 0){
            partial_rows++;
        }
    })
    return [total_hours, partial_rows];
}

export function get_sheet(id) {
    get('/sheets/'+id)
        .then((resp) => {
            store.dispatch({
                type: 'CHANGE_SHEET',
                data: [resp.data],
            });
        });
}

export function submit_time_sheet(form) {
    let state = store.getState();
    let data = state.forms.new_timesheet;
    let user_id = state.session.user_id;
    let errors = {}

    console.log("data",data)

    if (data.workdate == null) {
        errors["date"] = "Work Date cannot be empty."
    }else{
        if(new Date(data.workdate).getTime() > new Date().getTime())
        {
            errors["date"] = "Select a past date."
        }
    }

    let [total_hours,partial_rows] = validate_hours(data)
    if((data.num_of_tasks-partial_rows) == 0 ){
        errors["rows"] = "Please enter both hours and jobcode for atleast one task"
    }else{
        if ( total_hours > 8) {
            console.log("total hours", total_hours)
            errors["hours"] = "Total hours cannot exceed 8"
        } else if(total_hours == 0){
            errors["hours"] = "Minimum of 1 hour should be entered"
        }
    }

    if(Object.values(errors).length > 0){
        store.dispatch({
            type: 'ADD_ERRORS',
            data: {errors: errors},
        });
        return;
    }
    post('/sheets', {
        sheet: format_form_data(data, user_id)
    }).then((resp) => {
        console.log(resp);
        if (resp.data) {
            form.redirect('/sheets/' + resp.data.id);
        }else{
            if(resp.errors){
                store.dispatch({
                    type: 'ADD_ERRORS',
                    data: {errors: resp.errors},
                });
            }
        }
    });
}