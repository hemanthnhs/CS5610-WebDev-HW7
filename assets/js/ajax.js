import store from './store';
import React from "react";

export function post(path, body) {
    let state = store.getState();
    let token = state.session.token;

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

    return fetch('/ajax' + path, {
        method: 'get',
        credentials: 'same-origin',
        headers: new Headers({
            'x-csrf-token': window.csrf_token,
            'content-type': "application/json; charset=UTF-8",
            'accept': 'application/json',
            'x-auth': token || "",
        }),
    }).then((resp) => resp.json());
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

export function list_jobs() {
    get('/jobs')
        .then((resp) => {
            console.log("list_photos", resp);
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

export function submit_time_sheet(form) {
    let state = store.getState();
    let data = state.forms.new_timesheet;
    let user_id = state.session.user_id;
    //TODO Handle date, improper data, basically validations
    if (data.workdate == null) {
        return;
    }

    //TODO: Display errors
    post('/sheets', {
        sheet: format_form_data(data, user_id)
    }).then((resp) => {
        console.log(resp);
        if (resp.data) {
            form.redirect('/sheets/' + resp.data.id);
        }
    });
}