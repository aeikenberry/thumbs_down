import * as React from 'react'
import UserRow, { UserState } from './UserRow'

interface UsersState {
  users: UserState[]
}

export default class UserWidget extends React.Component<UsersState, {}> {
  constructor(props) {
    super(props)
  }

  public render(): JSX.Element {
    const users = this.props.users.map((u) =>
      <UserRow name={u.name} hasThumbsDown={u.hasThumbsDown} key={u.name}></UserRow>
    )
    return (
      <div className="user-widget">
        <h4>Users</h4>
        <ul>{users}</ul>
      </div>
    )
  }
}
