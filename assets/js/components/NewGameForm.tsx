import * as React from 'react'

export interface FormProps {
  csrf_token: string
  submitCallback: any
}

export default class NewGameForm extends React.Component<FormProps, {}> {
  constructor(props: any) {
    super(props)
  }

  private handleSubmit(event: any) {
    if (this.props.submitCallback) {
      event.preventDefault()
      this.props.submitCallback()
    }
  }

  public render(): JSX.Element {
    return (
      <form action="/games" method="POST" onSubmit={this.handleSubmit}>
        <input type="hidden" value={this.props.csrf_token} name="_csrf_token"/>
        <button className="btn btn-lg">Start a new game</button>
      </form>
    )
  }
}
