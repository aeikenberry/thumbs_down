import * as React from 'react'
import UserRow, { UserState } from './UserRow'

interface UsersState {
  users: UserState[]
  inGameUsers: string[]
  winner?: string
}

export default class UserWidget extends React.Component<UsersState, {}> {
  constructor(props) {
    super(props)
  }

  public render(): JSX.Element {
    const connectedUserNames = this.props.users.map((u) => u.name)

    const connectedUsers = this.props.users.sort().map((u) =>
      <UserRow
        name={u.name}
        hasThumbsDown={u.hasThumbsDown}
        key={u.name}
        inGame={this.props.inGameUsers ? this.props.inGameUsers.indexOf(u.name) > -1 : false}
        winner={this.props.winner}
      ></UserRow>
    )

    const notConnectedGameUsers = this.props.inGameUsers ? this.props.inGameUsers.filter(
      (name) => connectedUserNames.indexOf(name) < 0)
      .map((username) =>
      <UserRow
        name={username}
        hasThumbsDown={null}
        key={username}
        inGame={true}
        winner={this.props.winner}
      ></UserRow>
      ) : []

    return (
      <div className="user-widget">
        <h4>Users</h4>
        {this.props.winner === null && <div>
          <ul>{connectedUsers}</ul>
        </div>}
        {notConnectedGameUsers.length > 0 && <div>
          <ul>{notConnectedGameUsers}</ul>
        </div>}
      </div>
    )
  }
}
