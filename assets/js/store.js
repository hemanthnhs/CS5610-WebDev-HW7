import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze-strict';

function form(st0 = {work_date: null, num_of_tasks: 1, rows: {}}, action) {
    switch (action.type) {
        case 'ADD_ROW':
            return Object.assign({}, st0, {num_of_tasks: st0.num_of_tasks+1});
        case 'REMOVE_ROW':
            return Object.assign({}, st0, {num_of_tasks: st0.num_of_tasks-1});
        case 'SELECT_DATE':
            return Object.assign({}, st0, {work_date: action.data});
        default:
            return st0;
    }
}

function root_reducer(st0, action) {
    console.log("root reducer", st0, action);
    let reducer = combineReducers({
        form
    });
    return deepFreeze(reducer(st0, action));
}

let store = createStore(root_reducer);
export default store;