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
  render: ->
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
