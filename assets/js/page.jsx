import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Switch, Route, NavLink, Link } from 'react-router-dom';
import { Navbar, Nav, Col } from 'react-bootstrap';
import { Provider, connect } from 'react-redux';
import store from './store';
import NewSheet from './sheets/newSheet';
import Login from './login';

export default function init_page(root) {
    let tree = (
        <Provider store={store}>
            <Page />
        </Provider>
    );
    ReactDOM.render(tree, root);
}

function Page(props) {
    return (
        <Router>
            <Navbar id="nav-header" bg="primary" variant="dark">
                <Col md="8">
                    <Nav>
                        <Nav.Item>
                            <NavLink to="/" exact activeClassName="active" className="nav-link">
                                <h3>TimeSheets</h3>
                            </NavLink>
                        </Nav.Item>
                        <Nav.Item>
                            {/*This is for worker only*/}
                            <NavLink to="/newTimeSheet" exact activeClassName="active" className="nav-link">
                                Fill New TimeSheet
                            </NavLink>
                        </Nav.Item>
                    </Nav>
                </Col>
                <Col md="4">
                    <Session />
                </Col>
            </Navbar>

            <Switch>
                <Route exact path="/">
                    <h1>Home</h1>
                </Route>

                <Route exact path="/newTimeSheet">
                    <NewSheet />
                </Route>

                <Route exact path="/login">
                    <Login />
                </Route>
            </Switch>
        </Router>
    );
}

let Session = connect(({session}) => ({session}))(({session, dispatch}) => {
    function logout(ev) {
        ev.preventDefault();
        localStorage.removeItem('session');
        dispatch({
            type: 'LOG_OUT',
        });
    }
    console.log("sessionnnn",session)
    if (session) {
        return (
            <Nav>
                <Nav.Item>
                    <p className="text-light py-2">User: {session.user_name}</p>
                </Nav.Item>
                <Nav.Item>
                    <a className="nav-link" href="#" onClick={logout}>Logout</a>
                </Nav.Item>
            </Nav>
        );
    }
    else {
        return (
            <Nav>
                <Nav.Item>
                    <NavLink to="/login" exact activeClassName="active" className="nav-link">
                        Login
                    </NavLink>
                </Nav.Item>
            </Nav>
        );
    }
});