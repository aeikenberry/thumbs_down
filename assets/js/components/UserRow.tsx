import * as React from 'react'

export interface UserState {
  hasThumbsDown?: boolean
  name: string
  inGame?: boolean
  winner?: string
}

export default class UserRow extends React.Component<UserState, {}> {
  constructor(props) {
    super(props)
  }

  public render(): JSX.Element {
    const thumbDisplay = () => {
      if (this.props.hasThumbsDown === null) {
        return ''
      }

      return this.props.hasThumbsDown === true ? '👎' : '👍'
    }
    return (
      <li>
        <p>
          <strong>
          {this.props.name}
          </strong>
           {thumbDisplay()}
           {this.props.inGame === true ? '🎮' : ''}
           {this.props.winner === this.props.name ? '🏅': ''}
        </p>
      </li>
    )
  }
}
