import React from 'react';
import { Routes, Route, Link } from 'react-router-dom';
import 'fomantic-ui-css/semantic.css';
import Navbar from './components/Navbar.js';
import Home from './components/Home.js';
import About from './components/About.js';
import NoMatch from './components/NoMatch.js';
import Dashboard from './components/Dashboard.js';

const App = () => (
    <div className='AppContainer'>
        <Routes>
            <Route path='/' exact element={<Navbar />}>
                <Route index element={<Home />} />
                <Route path='dashboard/*' element={<Dashboard />} />
                <Route path='about' element={<About />} />
                <Route path='*' element={<NoMatch />} />
            </Route>
        </Routes>
    </div>
)

export default App;