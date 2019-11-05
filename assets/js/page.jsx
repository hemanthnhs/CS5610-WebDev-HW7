import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Switch, Route, NavLink, Link } from 'react-router-dom';
import { Navbar, Nav } from 'react-bootstrap';
import { Provider, connect } from 'react-redux';
import store from './store';
import NewSheet from './sheets/newSheet';

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
            </Navbar>

            <Switch>
                <Route exact path="/">
                    <h1>Home</h1>
                </Route>

                <Route exact path="/newTimeSheet">
                    <NewSheet />
                </Route>
            </Switch>
        </Router>
    );
}