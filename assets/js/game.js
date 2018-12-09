import {Socket} from "phoenix"

export default class ThumbsDown {
  constructor(roomId, name) {
    this.roomId = roomId
    this.username = name
    this.socket = new Socket("/socket", {})
    this.socket.connect()
    this.channel = this.socket.channel(`room:${roomId}`, {name: name})
  }

  setup() {
    this.channel.join()
      .receive('ok', this.handleEnter.bind(this))
      .receive('error', this.handleError.bind(this))
    this.channel.on('presence_state', this.handlePresenseState.bind(this))
    this.channel.on('presence_diff', this.handlePresenseChange.bind(this))
    this.channel.on('game_start', this.handleGameStart.bind(this))
    this.channel.on('game_over', this.handleGameOver.bind(this))
    this.channel.on('user_change', this.handleUserChange.bind(this))
  }

  handleEnter() {
    console.log('Joined Room')
  }

  handlePresenseChange(payload) {
    console.log('Received presense change', payload)
  }

  handlePresenseState(payload) {
    console.log('Presense State', payload)
  }

  handleError(err) {
    console.log(err)
  }

  handleGameStart() {

  }

  handleGameOver() {

  }

  handleUserChange() {

  }
}