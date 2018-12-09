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

declare global {
  interface Window { app: any }
}

// This code starts up the React app when it runs in a browser. It sets up the routing
// configuration and injects the app into a DOM element.

window.app = {
  startThumbsDown: (roomId, username) => {
    ReactDOM.render(
      <ThumbsDown roomId={roomId} username={username} />,
      document.getElementById('game-app')
    )
  }
}
