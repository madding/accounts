@RecordForm = React.createClass
    getInitialState: ->
      title: ''
      date: ''
      amount: ''
    handleChange: (e) ->
      @setState "#{ e.target.name }": e.target.value
    valid: ->
      @state.title && @state.date && @state.amount
    handleSubmit: (e) ->
      e.preventDefault()
      $.post 'records/', { record: @state }, (data) =>
        @props.handleNewRecord data
        @setState @getInitialState()
      , 'JSON'
    render: ->
      `<form className="form-inline" onSubmit={ this.handleSubmit }>
        <div className="form-group">
          <input type="text"
            className="form-control"
            placeholder="Date"
            name="date"
            value={ this.state.date }
            onChange={ this.handleChange } />
        </div>
        <div className="form-group">
          <input type="text"
            className="form-control"
            placeholder="Title"
            name="title"
            value={ this.state.title }
            onChange={ this.handleChange } />
        </div>
        <div className="form-group">
          <input type="number"
            className="form-control"
            placeholder="Amount"
            name="amount"
            value={ this.state.amount }
            onChange={ this.handleChange } />
        </div>

        <button type="submit"
          className="btn btn-primary"
          disabled={ !this.valid() }>
          Create record
        </button>
      </form>`