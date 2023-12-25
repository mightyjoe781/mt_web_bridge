import { Container, Card, Header } from 'semantic-ui-react';
import { useState, useEffect } from 'react';

async function fetchServerInfo() {
    return fetch('https://servers.minetest.net/list')
    .then((response) => response.json())
    .then((responseJson) => {
      return responseJson.list
    })
    .catch((error) => {
      console.error(error);
    });
 }

function countdown(s) {
    const d = Math.floor(s / (3600 * 24));
    s  -= d * 3600 * 24;
    const h = Math.floor(s / 3600);
    s  -= h * 3600;
    const m = Math.floor(s / 60);
    s  -= m * 60;
    const tmp = [];
    (d) && tmp.push(d + 'd');
    (d || h) && tmp.push(h + 'h');
    (d || h || m) && tmp.push(m + 'm');
    tmp.push(s + 's');
    return tmp.join(' ');
}

function ServerInfo (props) {
    const serverName = props.value;
    const [server, setServer] = useState(()=> {
        fetchServerInfo().then(
            result => {
                result.forEach(srv => {
                    if(srv.name === serverName) {
                        setServer(srv)
                        console.log(srv)
                    }
                })
            }
        )
    });

    useEffect(
        ()=>{
        console.log("Use Effect is called")
        let timer1 = setInterval(()=>
        fetchServerInfo().then(
                result => {
                    result.forEach(srv => {
                        if(srv.name === serverName) {
                            setServer(srv)
                        }
                    })
                }
        ), 5000)
        return ()=> {
            // cleanup call
            console.log("Cleanup!")
            clearInterval(timer1)
        }
    },[serverName]);

    if(!server) {
        const playerCount = 'Resolving Request...'
        return <PlayerCount {...props} playerCount={playerCount} />
    }

    const playerCount = server.clients
    const restartTime = new Date(new Date() - server.uptime*1000).toLocaleString()
    const elapsedTime = countdown(server.uptime)
    return (
        <div className='container'>
            <div>
                Total Players on {props.value} : {playerCount}
            </div>
            <div>
                All time player count : {server.total_clients}
            </div>
            <div>
                Current Lag : <span style={server.ping > 0.1? {color:"red"}: {color:"green"}} children={server.ping.toFixed(5)} /> ms
            </div>
            <div>
                Last server restart time : {restartTime} ({elapsedTime} ago)
            </div>
            <ul>
                {server.clients_list.map((playerName,i) => <li key={i} >{playerName}</li>) }
            </ul>
        </div>
    );
}

function PlayerCount (props) {
    return (
        <div className='container'>
            <div>
             Total Players on {props.value} : {props.playerCount}
            </div>
        </div>
    );
}


function Dashboard() {
    const servers = ["Prismo", "Adventure Time", "SurvivalGo", "Avalon"];
    const cards = servers.map((item) => (
      <Card key={item}><ServerInfo value={item} /></Card>
    )).reduce((pre, cur) => pre.concat(cur), []);

    return (
        <>
        <Container fluid textAlign='center'>
            <Header as='h2'> Server Stats</Header>
            <Card.Group centered>
                {cards}
            </Card.Group>
        </Container>
        </>
    );
}

export default Dashboard;