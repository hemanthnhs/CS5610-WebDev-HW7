import React from 'react';
import ReactDOM from 'react-dom';
import {Redirect} from 'react-router';
import {connect} from 'react-redux';
import {Form, Button, Table} from 'react-bootstrap';

function state2props(state) {
    console.log(state.form)
    return state.form;
}

class NewSheet extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            redirect: null,
        }
        this.select_date = this.select_date.bind(this)
    }

    select_date(ev) {
        console.log(ev.target.value)
        this.props.dispatch({
            type: 'SELECT_DATE',
            data: ev.target.value,
        });
    }

    add_row(curr_tasks) {
        if(curr_tasks < 8 ){
            this.props.dispatch({
                type: 'ADD_ROW'
            });
        }
    }

    remove_row(curr_tasks) {
        if(curr_tasks >1 ) {
            this.props.dispatch({
                type: 'REMOVE_ROW'
            });
        }
    }

    render() {
        let {work_date, num_of_tasks, logs_data, dispatch} = this.props;
        let row_data = []
        for (var i = 1; i <= num_of_tasks; i++) {
            row_data.push(<tr>
                <td>{i}</td>
                <td><Form.Control as="select">
                    <option>1</option>
                    <option>2</option>
                    <option>3</option>
                    <option>4</option>
                    <option>5</option>
                </Form.Control></td>
                <td><Form.Control type="number" max={8} min={1}/></td>
                <td><Form.Control type="text" placeholder="Short description"/></td>
            </tr>)
        }
        return (
            <div>
                <div className="row">
                    <h1>Fill New TimeSheet</h1>
                    <Form.Group className="offset-lg-5 offset-4" controlId="submit">
                        <Button variant="success">Submit Work</Button>
                    </Form.Group>
                </div>
                <Form.Group className="row" controlId="workdate">
                    <Form.Label>Work Date</Form.Label>
                    <Form.Control className="offset-1 col-3" type="date" onChange={(ev) => this.select_date(ev)}/>
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