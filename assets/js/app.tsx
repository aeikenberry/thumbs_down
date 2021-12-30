import * as React from 'react'
import * as ReactDOM from 'react-dom'

// webpack automatically concatenates all files in your
// watched paths. Those paths can be configured as
// endpoints in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html'
import ThumbsDown from './components/ThumbsDown'
import NewGameForm from './components/NewGameForm'

declare global {
  interface Window { app: any }
}

// This code starts up the React app when it runs in a browser. It sets up the routing
// configuration and injects the app into a DOM element.

window.app = {
  startThumbsDown: (roomId, username, token) => {
    ReactDOM.render(
      <ThumbsDown roomId={roomId} username={username} csrf_token={token} />,
      document.getElementById('game-app')
    )
  },

  showNewGameForm: (token, elId) => {
    ReactDOM.render(
      <NewGameForm csrf_token={token} submitCallback={null} />,
      document.getElementById(elId)
    )
  },

  setCookie: (name, value, days) => {
    let expires = ''
    if (days) {
      const date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = '; expires=' + date.toUTCString()
    }
    document.cookie = name + '=' + (value || '')  + expires + '; path=/'
  },

  getCookie: (name) => {
    const nameEQ = name + '='
    const ca = document.cookie.split(';')
    for (let i = 0;i < ca.length; i++) {
        let c = ca[i]
        while (c.charAt(0) === ' ') c = c.substring(1, c.length)
        if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length)
    }
    return null
  },

  eraseCookie: (name) => {
    document.cookie = name + '=; Max-Age=-99999999;'
  }
}
