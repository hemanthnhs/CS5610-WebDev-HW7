import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze-strict';

function login(st0 = {email: "", password: "", errors: null}, action) {
    switch(action.type) {
        case 'CHANGE_LOGIN':
            return Object.assign({}, st0, action.data);
        default:
            return st0;
    }
}

function sheets(st0 = new Map(), action) {
    switch (action.type) {
        case 'CHANGE_SHEET':
            console.log("action", action)
            let st1 = new Map(st0);
            for (let sheet of action.data) {
                st1.set(sheet.id, sheet);
            }
            return st1;
        default:
            return st0;
    }
}

function row_update(st0, action, field){
    console.log("came")
    let parsedId = parseInt(action.id)
    console.log("state",st0)
    var updated_rows = new Map(st0.logs);
    var changing_row = updated_rows.get(parsedId);
    switch (action.updated_key) {
        case 'jobcode':
            changing_row.job_id = action.data
            break;
        case 'hours':
            changing_row.hours = action.data
            break;
        case 'work_notes':
            changing_row.desc = action.data
            break;
        default:
            changing_row = changing_row
    }
    updated_rows.set(parsedId, changing_row)
    return Object.assign({}, st0, {logs: updated_rows});
}

function new_timesheet(st0 = {workdate: null, num_of_tasks: 1, logs: new Map([[1,{job_id:-1,hours:0,desc:""}]]), errors:null}, action) {
    switch (action.type) {
        case 'ADD_ROW':
            let curr_row = st0.num_of_tasks+1
            var updated_rows = new Map(st0.logs);
            updated_rows.set(curr_row,{job_id:-1,hours:0,desc:""})
            return Object.assign({}, st0, {num_of_tasks: st0.num_of_tasks+1, logs: updated_rows});
        case 'REMOVE_ROW':
            var updated_rows = st0.logs
            updated_rows.delete(st0.num_of_tasks)
            return Object.assign({}, st0, {num_of_tasks: st0.num_of_tasks-1, logs: updated_rows});
        case 'SELECT_DATE':
            return Object.assign({}, st0, {workdate: action.data});
        case 'CHANGE_TASK_DATA':
            return row_update(st0, action)
        case 'ADD_ERRORS':
            return Object.assign({}, st0, {errors: action.data.errors});
        case 'NEW_FORM':
            return {workdate: null, num_of_tasks: 1, logs: new Map([[1,{job_id:-1,hours:0,desc:""}]]), errors:null}
        default:
            return st0;
    }
}

function jobs(st0 = new Map(), action) {
    switch (action.type) {
        case 'ADD_JOBS':
            let st1 = new Map(st0);
            for (let job of action.data) {
                st1.set(job.id, job);
            }
            return st1;
        default:
            return st0;
    }
}

function alerts(st0 = [{id: 1, type: "warning", message: "Test Alert"}], action) {
    switch (action.type) {
        case 'NEW_ALERTS':
            var st1 = st0.slice(0)
            st1.push({type: "warning", id: action.data["sheet_id"], message: action.data["message"]})
            return st1;
        case 'REMOVE_ALERT':
            var st1 = st0
            let id = st1.indexOf(action.data);
            return [...st1.slice(0, id), ...st1.slice(id + 1)]
        default:
            return st0;
    }
}

function forms(st0, action) {
    let reducer = combineReducers({
        new_timesheet,
        login,
    });
    return reducer(st0, action);
}

let session0 = localStorage.getItem('session');
if (session0) {
    session0 = JSON.parse(session0);
}
function session(st0 = session0, action) {
    switch (action.type) {
        case 'LOG_IN':
            return action.data;
        case 'LOG_OUT':
            return null;
        default:
            return st0;
    }
}

function root_reducer(st0, action) {
    let reducer = combineReducers({
        forms,
        session,
        sheets,
        jobs,
        alerts,
    });
    return deepFreeze(reducer(st0, action));
}

let store = createStore(root_reducer);
export default store;