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
    return (
      <div
        className="thumb-zone"
        onMouseLeave={this.handleUp.bind(this)}
        onMouseDown={this.handleDown.bind(this)}
        onMouseUp={this.handleUp.bind(this)}
      >
        <p>{this.state.active ? 'HOLD ON' : 'Press Here To Start'}</p>
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
