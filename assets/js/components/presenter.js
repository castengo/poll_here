import React from 'react'
import channel from '../socket'

class Presenter extends React.Component {
  constructor(props) {
    super(props)

    this.submitQuestion = this.submitQuestion.bind(this)
    this.updateQuestion = this.updateQuestion.bind(this)
    this.state = {
      answers: [],
      newQuestion: '',
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
    console.log(this.state.question)
    return (
      <div>
        <form onSubmit={ this.submitQuestion }>
          <input
            onChange={ this.updateQuestion }
            value={ this.state.newQuestion }
            type='text' />
          <button
            className='btn'
            onClick={ this.submitQuestion }
            type='submit'>
            Submit
          </button>
        </form>
        <h1>{ this.state.question }</h1>
        <ul>
          { this.state.answers.map( (answer, index) => {
            return <li key={index}>{ answer }</li>
          })}
        </ul>
      </div>
    )
  }

  submitQuestion(event) {
    event.preventDefault()
    channel.push('new_question', this.state.newQuestion)
    this.setState({newQuestion: ''})
  }

  updateQuestion(event) {
    this.setState({newQuestion: event.target.value})
  }
}

export default Presenter
