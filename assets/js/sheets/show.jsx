import React from 'react';

import {connect} from 'react-redux';
import {Table, Button} from 'react-bootstrap';
import {get_sheet, approve_sheet, list_sheets} from '../ajax';
import { Redirect } from 'react-router';
import {get_channel, join_channel} from "../channel";
import {AlertList} from "react-bs-notifier";
import store from "../store";

function state2props(state, props) {
    let id = parseInt(props.id);
    if(state.session == null){
        return {
            id: null,
            sheet: null,
            user_id: null,
            is_manager: null,
            alerts: null
        };
    }
    else{
        return {
            id: id,
            sheet: state.sheets.get(id),
            user_id: state.session.user_id,
            is_manager: state.session.is_manager,
            alerts: state.alerts
        };
    }
}

class ShowSheet extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            redirect: null,
        }

        if (props.is_manager) {
            let channel = get_channel()
            if (channel == null) {
                channel = join_channel(props.user_id, list_sheets)
            }
        }

        if(props.user_id != null){
            get_sheet(props.id)
        }
    }

    redirect(path) {
        this.setState({redirect: path});
    }

    onAlertDismissed(alert) {
        store.dispatch({
            type: 'REMOVE_ALERT',
            data: alert
        });
    }

    render() {
        let {id, sheet, is_manager, user_id, alerts} = this.props;
        if(user_id == null){
            return (<div>Please login to access</div>)
        }
        let alert_display = null

        if (alerts != "") {
            alert_display = <AlertList timeout={15000} onDismiss={this.onAlertDismissed.bind(this)} alerts={alerts}/>
        }
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
                {alert_display}
                <h1>Time Sheet Information</h1>
                {is_manager ? <h4>Requested by: {sheet.user_name}</h4> : null}
                <h4>Approval Status: {sheet.approved ? "Approved" : ((is_manager) ?
                    <span><span>Not yet Approved </span><Button className="approve" variant="success"
                                                                onClick={() => approve_sheet(sheet.id)}>Approve</Button></span> : "Pending Approval")} </h4>
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
                            return (<tr>
                                <td>{ind + 1}</td>
                                <td>{log.jobcode}</td>
                                <td>{log.hours}</td>
                                <td>{log.desc}</td>
                            </tr>)
                        })
                    }
                    </tbody>
                </Table>
            </div>
        );
    }
}

export default connect(state2props)(ShowSheet);