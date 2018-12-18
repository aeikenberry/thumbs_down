import * as React from 'react'
import { Channel, Socket } from 'phoenix'
import UserWidget from './UserWidget'
import { UserState } from './UserRow'
import { find, omit } from 'lodash'
import ThumbZone, { ThumbState } from './ThumbZone'

interface GameState {
  rawUsers: UserMap
  users: UserState[]
  socket: Socket
  channel?: Channel
  starting?: false
  active?: false
}

interface GameProps {
  roomId: string
  username: string
}

interface PresenseEvent {
  joins: UserMap
  leaves: UserMap
}

interface UserMap {
  [username: string]: UserDetail
}

interface UserDetail {
  metas: any[]
}

const initialState = {
  socket: new Socket('/socket', {}),
  users: [],
  rawUsers: {}
}

export default class ThumbsDown extends React.Component<GameProps, GameState> {
  constructor(props) {
    super(props)
    this.state = initialState
    this.setup()
  }

  public render(): JSX.Element {
    return (
      <div>
        <p>Once thumbs are down, the game will start</p>
        <ThumbZone changeCallback={this.thumbCallback.bind(this)}></ThumbZone>
        <UserWidget users={this.state.users}></UserWidget>
      </div>
    )
  }

  private setup(): void {
    this.state.socket.connect()
    this.state = {
      ...this.state,
      channel: this.state.socket.channel(
        `room:${this.props.roomId}`,
        { name: this.props.username }
      )
    }
    this.state.channel.join()
      .receive('ok', this.handleEnter.bind(this))
      .receive('error', this.handleError.bind(this))
    this.state.channel.on('presence_state', this.handlePresenseState.bind(this))
    this.state.channel.on('presence_diff', this.handlePresenseChange.bind(this))
    this.state.channel.on('game_update', this.handleGameUpdate.bind(this))
  }

  private handleGameUpdate(e) {
    console.log('Game Update', e)
  }

  private handleEnter() {
    console.log('Joined Successfully')
  }

  private handleError(e: any) {
    console.log(e)
  }

  private handlePresenseState(e: UserMap) {
    this.setState({
      rawUsers: e,
      users: this.transformRawUsers(e),
     })
  }

  private handlePresenseChange(e: PresenseEvent) {
    const rawUsers = {
      ...omit(this.state.rawUsers, Object.keys(e.leaves)),
      ...e.joins
    }
    this.setState({
      rawUsers,
      users: this.transformRawUsers(rawUsers),
    })
  }

  private transformRawUsers(raw: UserMap): UserState[] {
    return Object.keys(raw).map((username) => ({
      name: username,
      hasThumbsDown: raw[username].metas[0].thumb_down as boolean
    }))
  }

  private thumbCallback(e: ThumbState) {
    if (this.myThumbChanged(e.active)) {
      this.state.channel.push('thumb_change', {
        is_down: e.active
      })
    }
  }

  private myThumbChanged(newValue: boolean): boolean {
    const me = find(this.state.users, (user) => user.name === this.props.username)
    return me.hasThumbsDown != newValue
  }
}
