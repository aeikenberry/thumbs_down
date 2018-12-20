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
    const users = this.props.users.sort().map((u) =>
      <UserRow
        name={u.name}
        hasThumbsDown={u.hasThumbsDown}
        key={u.name}
        inGame={this.props.inGameUsers ? this.props.inGameUsers.indexOf(u.name) > -1 : false}
        winner={this.props.winner}
      ></UserRow>
    )
    return (
      <div className="user-widget">
        <h4>Users</h4>
        <ul>{users}</ul>
      </div>
    )
  }
}
