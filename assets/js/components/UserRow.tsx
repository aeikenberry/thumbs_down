import * as React from 'react'

export interface UserState {
  hasThumbsDown?: boolean
  name: string
  inGame: boolean
  winner?: string
}

export default class UserRow extends React.Component<UserState, {}> {
  constructor(props) {
    super(props)
  }

  public render(): JSX.Element {
    return (
      <li>
        <p>
          <strong>
          {this.props.name}
          </strong>
           {this.props.hasThumbsDown === true ? '👎' : '👍'}
           {this.props.inGame === true ? '🎮' : ''}
           {this.props.winner === this.props.name ? '🏅': ''}
        </p>
      </li>
    )
  }
}
