/* Imports */
import React from "react";
import App from "./App.js";

import { BrowserRouter } from 'react-router-dom';
import { createRoot } from 'react-dom/client';

/* Render the DOM */
const container = document.getElementById('root')
const root = createRoot(container)
root.render(
    <BrowserRouter>
        <App />
    </BrowserRouter>
)