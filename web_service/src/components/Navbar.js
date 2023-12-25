import React, { useState } from 'react'
import { Link, Outlet } from 'react-router-dom'
import { Menu, Header } from 'semantic-ui-react'

function Navbar() {
    const [activeItem, setActiveItem] = useState('')
    var handleItemClick = (e, {name}) => setActiveItem(name)
    return (
        <>
        <Menu secondary size='huge' attached='top' color='black' inverted>
            <Menu.Item name='mt_console'>
                <Link to='/'><Header as='h1' inverted>MT CONSOLE</Header></Link>
            </Menu.Item>
            <Menu.Item
                name='dashboard'
                active={activeItem === 'dashboard'}
                onClick={handleItemClick}
                as={Link} to='/dashboard'
            >
                Dashboard
            </Menu.Item>
            <Menu.Item
                name='editorial'
                active={activeItem === 'editorial'}
                onClick={handleItemClick}
                as={Link} to='/editorial'
            >
                Editorial
            </Menu.Item>
            <Menu.Item
                name='about'
                active={activeItem === 'about'}
                onClick={handleItemClick}
                as={Link} to='/about'
            >
                About
            </Menu.Item>
        </Menu>
        <Outlet />
        </>
    )


}

export default Navbar;