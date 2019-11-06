import React from 'react';
import ReactDOM from 'react-dom';

import { connect } from 'react-redux';
import {Table} from 'react-bootstrap';
import { get_sheet } from '../ajax';

function state2props(state, props) {
    let id = parseInt(props.id);
    return {id: id, sheet: state.sheets.get(id)};
}

function ShowSheet({id, sheet}) {

    if (!sheet) {
        get_sheet(id);

        return (
            <div>
                <h1>Sheet Information</h1>
                <p>Loading...</p>
            </div>
        );
    }

    return (
        <div>
            <h1>Time Sheet Information</h1>
            <h4>Approval Status: {sheet.approved? "Approved" : "Pending Approval"} </h4>
            <h4>Work Date: {sheet.workdate}</h4>
            <Table striped hover>
                <thead>
                <tr>
                    <th>#</th>
                    <th>Job Code</th>
                    <th>Hours</th>
                    <th>Work Notes</th>
                </tr>
                </thead>
                <tbody>
            {
                sheet.logs.map(function (log, ind) {
                    return (<tr><td>{ind+1}</td><td>{log.jobcode}</td><td>{log.hours}</td><td>{log.desc}</td></tr>)
                })
            }
                </tbody>
            </Table>
        </div>
    );
}

export default connect(state2props)(ShowSheet);