import React from 'react';

import {connect} from 'react-redux';
import {Table, Button} from 'react-bootstrap';
import {get_sheet, approve_sheet} from '../ajax';

function state2props(state, props) {
    let id = parseInt(props.id);
    return {id: id, sheet: state.sheets.get(id), is_manager: state.session.is_manager};
}

class ShowSheet extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            redirect: null,
        }
        console.log(props)
        get_sheet(props.id)
    }

    redirect(path) {
        this.setState({redirect: path});
    }

    render() {
        let {id, sheet, is_manager} = this.props;
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
                <h4>Approval Status: {sheet.approved ? "Approved" : ((is_manager) ? <span><span>Not yet Approved </span><Button className="approve" variant="success" onClick={() => approve_sheet(sheet.id)}>Approve</Button></span> : "Pending Approval")} </h4>
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