R = React.DOM

@Record = React.createClass
  getInitialState: ->
    edit: false
  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit
  handleDelete: (e) ->
    e.preventDefault()

    $.post "/records/#{ @props.record.id }", { _method: 'delete' },
      (data) =>
        @props.handleDeleteRecord @props.record
      , 'JSON'
  recordForm: ->
    `<tr>
      <td>
        <input
          className="form-control"
          type="text"
          defaultValue={ this.props.record.date }
          ref="date" />
      </td>
      <td>
        <input
          className="form-control"
          type="text"
          defaultValue={ this.props.record.title }
          ref="title" />
      </td>
      <td>
        <input
          className="form-control"
          type="number"
          defaultValue={ this.props.record.amount }
          ref="amount" />
      </td>
      <td>
        <a
          className="btn btn-default"
          onClick={ this.handleEdit } >
          Update
        </a>
        <a
          className="btn btn-danger"
          onClick={ this.handleToggle } >
          Cancel
        </a>
      </td>
    </tr>`
  recordRow: ->
    `<tr>
      <td>{ this.props.record.date }</td>
      <td>{ this.props.record.title }</td>
      <td>{ amountFormat(this.props.record.amount) }</td>
      <td>
        <a onClick={ this.handleToggle } className="btn btn-default">
          Edit
        </a>
        <a onClick={ this.handleDelete } className="btn btn-danger">
          Delete
        </a>
      </td>
    </tr>`
  render: ->
    if @state.edit
      @recordForm()
    else
      @recordRow()
