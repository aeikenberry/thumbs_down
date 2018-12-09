import * as React from 'react'
import { Channel, Socket } from 'phoenix'
import UserWidget from './UserWidget'
import { UserState } from './UserRow'
import { omit } from 'lodash'

interface GameState {
  rawUsers: UserMap
  users: UserState[]
  socket: Socket
  channel?: Channel
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
        <h2>Game</h2>
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
      hasThumbsDown: false
    }))
  }
}
