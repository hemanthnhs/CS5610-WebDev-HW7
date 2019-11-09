import React from 'react';
import {connect} from 'react-redux';
import {Button, Table} from 'react-bootstrap';
import {Redirect} from 'react-router';
import {AlertList, Alert} from "react-bs-notifier";

import {list_sheets, approve_sheet} from './ajax';
import {get_channel, join_channel} from './channel';
import store from "./store";

class Dashboard extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            redirect: null,
        };
        list_sheets()

        let channel = get_channel()
        if (channel == null) {
            join_channel(this.props.id, list_sheets)
        }
    }

    redirect(path) {
        this.setState({
            redirect: path,
        });
    }

    open_sheet(id) {
        this.setState({
            redirect: "/sheets/" + id,
        });
    }

    onAlertDismissed(alert) {
        store.dispatch({
            type: 'REMOVE_ALERT',
            data: alert
        });
    }

    render() {
        if (this.state.redirect) {
            return <Redirect to={this.state.redirect}/>
        }

        let {id, sheets, is_manager, supervisor_id, alerts} = this.props
        let alert_display = null

        if (alerts != "") {
            alert_display = <AlertList timeout={15000} onDismiss={this.onAlertDismissed.bind(this)} alerts={alerts}/>
        }

        var display_rows = []
        var that = this
        Array.from(sheets.keys()).sort(function(a,b) { return b - a; }).map(function (sheet_id, index) {
            let sheet = sheets.get(sheet_id)
            display_rows.push(<tr key={sheet_id}>
                {is_manager ? <td>{sheet.user_name}</td> : null}
                <td>{sheet.workdate}</td>
                <td>{sheet.approved ? "Approved" : "Pending Approval"}</td>
                <td>
                    <Button variant="primary" onClick={() => that.open_sheet(sheet.id)}>View</Button>
                    {is_manager ? (sheet.approved ? null : <Button className="approve" variant="success"
                                                                   onClick={() => approve_sheet(sheet.id)}>Approve</Button>) : null}
                </td>
            </tr>)
        });

        return (
            <div>
                {alert_display}
                <h1>Dashboard</h1>
                {(sheets.size != 0) ?
                    <Table striped hover>
                        <thead>
                        <tr>
                            {is_manager ? <th>Requested By</th> : null}
                            <th>Work Date</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        {display_rows}
                        </tbody>
                    </Table> : null
                }
            </div>
        );
    }
}

function state2props(state) {
    return {
        id: state.session.user_id,
        sheets: state.sheets,
        is_manager: state.session.is_manager,
        supervisor_id: state.session.supervisor_id,
        alerts: state.alerts
    };
}

export default connect(state2props)(Dashboard);