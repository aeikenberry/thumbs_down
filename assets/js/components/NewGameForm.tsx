import * as React from 'react'

export interface FormProps {
  csrf_token: string
}

export default class NewGameForm extends React.Component<FormProps, {}> {
  constructor(props: any) {
    super(props)
  }

  public render(): JSX.Element {
    return (
      <form action="/games" method="POST">
        <input type="hidden" value={this.props.csrf_token} name="_csrf_token"/>
        <button className="btn btn-lg">Start a new game</button>
      </form>
    )
  }
}
