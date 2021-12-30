import * as React from 'react'

export interface Props {
  changeCallback: any
}

export interface ThumbState {
  active?: boolean
}

const inititalState = { active: false }

export default class ThumbZone extends React.Component<Props, ThumbState> {
  public node = React.createRef() as any

  constructor(props) {
    super(props)
    this.state = inititalState
  }

  public componentDidMount() {
    this.node.current.ontouchstart = this.handleDown.bind(this)
    window.addEventListener("blur", this.handleUp.bind(this))
  }

  public render(): JSX.Element {
    let classes = 'thumb-zone'
    if (this.state.active) {
      classes += ' active'
    }
    return (
      <div
        className={classes}
        ref={this.node}
        onMouseLeave={this.handleUp.bind(this)}
        onMouseDown={this.handleDown.bind(this)}
        onMouseUp={this.handleUp.bind(this)}
        onTouchCancel={this.handleUp.bind(this)}
        onTouchEnd={this.handleUp.bind(this)}
      >
        <p className="text-center">
          {this.state.active ? 'Stay down, don\'t drag outside the box' : 'Press and Hold Here To Start'}
        </p>
      </div>
    )
  }

  private handleDown(e: any) {
    e.preventDefault()
    this.props.changeCallback({ active: true })
    this.setState({ active: true })
  }

  private handleUp(e: any) {
    e.preventDefault()
    this.props.changeCallback({ active: false })
    this.setState({ active: false })
  }
}
