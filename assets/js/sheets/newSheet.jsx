import React from 'react';
import { Redirect } from 'react-router';
import {list_jobs, submit_time_sheet} from '../ajax';
import {connect} from 'react-redux';
import {Form, Button, Table, Alert} from 'react-bootstrap';

function state2props(state) {
    return {form: state.forms.new_timesheet, jobs: state.jobs, logged: !(state.session==null)};
}

class NewSheet extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            redirect: null,
        }

        this.props.dispatch({
            type: 'NEW_FORM',
        });
        if(props.logged) {
            list_jobs()
            this.select_date = this.select_date.bind(this)
        }
    }

    redirect(path) {
        this.setState({redirect: path});
    }

    select_date(ev) {
        console.log(ev.target.value)
        this.props.dispatch({
            type: 'SELECT_DATE',
            data: ev.target.value,
        });
    }

    change_task_data(ev, updated_key){
        console.log("for task", ev.target.id,"job",ev.target.value)
        this.props.dispatch({
            type: 'CHANGE_TASK_DATA',
            id: ev.target.id,
            data: ev.target.value,
            updated_key: updated_key
        });
    }

    add_row(curr_tasks) {
        if (curr_tasks < 8) {
            this.props.dispatch({
                type: 'ADD_ROW'
            });
        }
    }

    remove_row(curr_tasks) {
        if (curr_tasks > 1) {
            this.props.dispatch({
                type: 'REMOVE_ROW'
            });
        }
    }

    render() {
        if (this.state.redirect) {
            return <Redirect to={this.state.redirect} />;
        }
        if(!this.props.logged){
            return (<div>Please login to access</div>)
        }
        let {workdate, num_of_tasks, logs_data, errors, dispatch} = this.props.form;
        let error_display = null
        if (errors) {
            let e = []
            Object.values(errors).forEach(function(error){
                e.push(<div>{error}</div>)
            })
            error_display = <Alert variant="danger">{ e }</Alert>;
        }
        let jobs = this.props.jobs
        let options_data = [<option key={-1} value={-1} disabled hidden>Select Job Code</option>]
        jobs.forEach(function (job) {
            options_data.push(<option key={job.id} value={job.id}>{job.jobcode}</option>)
        })
        let row_data = []
        for (var i = 1; i <= num_of_tasks; i++) {
            row_data.push(<tr key={i}>
                <td>{i}</td>
                <td><Form.Control as="select" id={i} onChange={(ev) => this.change_task_data(ev,"jobcode")} defaultValue={-1}>{options_data}</Form.Control></td>
                <td><Form.Control type="number" id={i} max={8} min={1} onChange={(ev) => this.change_task_data(ev,"hours")}/></td>
                <td><Form.Control type="text" id={i} placeholder="Short description"  onChange={(ev) => this.change_task_data(ev,"work_notes")}/></td>
            </tr>)
        }
        return (
            <div>
                <div className="row">
                    <h1>Fill New TimeSheet</h1>
                    <Form.Group className="offset-lg-5 offset-4" controlId="submit">
                        <Button variant="success" onClick={() => submit_time_sheet(this)}>Submit Work</Button>
                    </Form.Group>
                </div>
                {error_display}
                <Form.Group className="row" controlId="workdate">
                    <Form.Label>Work Date</Form.Label>
                    <Form.Control className="offset-1 col-3" type="date" required={true} onChange={(ev) => this.select_date(ev)}/>
                </Form.Group>
                <Form.Group className="row">
                    <Form.Label>Number of tasks: </Form.Label>
                    <Form.Control className="col-1" type="number" value={num_of_tasks} disabled/>
                    <Button variant="info" onClick={() => this.add_row(num_of_tasks)}>+</Button>
                    <Button variant="warning" onClick={() => this.remove_row(num_of_tasks)}>-</Button>
                </Form.Group>
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
                        row_data
                    }
                    </tbody>
                </Table>
            </div>
        );
    }
}

export default connect(state2props)(NewSheet);