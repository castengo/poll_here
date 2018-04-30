import React from 'react'
import channel from '../socket'

class Poll extends React.Component {
  constructor(props) {
    super(props)

    this.sendMessage = this.sendMessage.bind(this)
    this.updateMessage = this.updateMessage.bind(this)
    this.state = {
      answers: [],
      newAnswer: '',
      question: ''
    }
  }

  componentDidMount() {
    // Gets initial state
    channel.push('get', {})
      .receive('ok', resp => {
        this.setState({
          answers: resp.answers,
          question: resp.question,
        })
      })

    // Listener for changes in state
    channel.on('new_state', resp => {
      this.setState({
        answers: resp.answers,
        question: resp.question
      })
    })
  }

  render() {
    return (
      <div>
        <h1>{ this.state.question }</h1>
        <ul>
          { this.state.answers.map( (answer, index) => {
            return <li key={index}>{ answer }</li>
          })}
        </ul>
        <form onSubmit={ this.sendMessage }>
          <input
            onChange={ this.updateMessage }
            value={ this.state.newAnswer }
            type='text' />
          <button
            className='btn'
            onClick={ this.sendMessage }
            type='submit'>
            Send
          </button>
        </form>
      </div>
    )
  }

  sendMessage(event) {
    event.preventDefault()
    channel.push('new_answer', this.state.newAnswer)
    this.setState({newAnswer: ''})
  }

  updateMessage(event) {
    this.setState({newAnswer: event.target.value})
  }
}

export default Poll
