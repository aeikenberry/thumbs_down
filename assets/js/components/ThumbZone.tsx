import * as React from 'react'

export interface Props {
  changeCallback: any
}

export interface ThumbState {
  active?: boolean
}

const inititalState = { active: false }

export default class ThumbZone extends React.Component<Props, ThumbState> {
  constructor(props) {
    super(props)
    this.state = inititalState
  }

  public render(): JSX.Element {
    let classes = 'thumb-zone'
    if (this.state.active) {
      classes += ' active'
    }
    return (
      <div
        className={classes}
        onMouseLeave={this.handleUp.bind(this)}
        onMouseDown={this.handleDown.bind(this)}
        onMouseUp={this.handleUp.bind(this)}
        onTouchStart={this.handleDown.bind(this)}
        onTouchCancel={this.handleUp.bind(this)}
        onTouchEnd={this.handleUp.bind(this)}
      >
        <p className="text-center">
          {this.state.active ? 'HOLD ON' : 'Press Here To Start'}
        </p>
      </div>
    )
  }

  private handleDown(e) {
    e.preventDefault()
    this.props.changeCallback({ active: true })
    this.setState({ active: true })
  }

  private handleUp(e) {
    e.preventDefault()
    this.props.changeCallback({ active: false })
    this.setState({ active: false })
  }
}
