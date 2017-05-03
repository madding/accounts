@Records = React.createClass
  getInitialState: ->
    records: @props.data
    uuid: @props.uuid
  getDefaultProps: ->
    records: []
  componentDidMount: ->
    App.cable.subscriptions.create { channel: 'UpdatesChannel', room: 'records' },
      connected: ->
        console.log 'connected'
      disconnected: ->
        console.log 'disconnected'
      received: @haveUpdates
  haveUpdates: (params) ->
    record = @state.records.filter((rec) -> rec.id == params.body.id)[0]

    switch params.method
      when "delete"
        if record && params.uuid != @state.uuid
          @deleteRecord record
      when "update"
        if record && params.uuid != @state.uuid
          @updateRecordLocal record, params.body
      when "create" && params.uuid != @state.uuid
        # TODO: check this
        if !record
          @addRecord params.body
      else console.log(data)
  addRecord: (record) ->
    records = @state.records.slice()
    records.push record
    @setState records: records
  deleteRecord: (record) ->
    records = @state.records.slice()
    records.splice records.indexOf(record), 1
    @replaceState records: records
  updateRecordLocal: (record, data) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1, data]] })
    @replaceState records: records, uuid: @state.uuid
  updateRecord: (record, data) ->
    $.post "records/#{ record.id }",
      { _method: 'put', record: data, uuid: @state.uuid },
      (data) => @updateRecordLocal(record, data),
      'JSON'
  credits: ->
    credits = @state.records.filter (val) -> val.amount >= 0
    credits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  debits: ->
    debits = @state.records.filter (val) -> val.amount < 0
    debits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  balance: ->
    @debits() + @credits()
  render: ->
    `<div className="records">
      <h2 className="title">Records</h2>
      <div className="row">
        <AmountBox type="success" amount={ this.credits() } text="Credit" />
        <AmountBox type="danger" amount={ this.debits() } text="Debit" />
        <AmountBox type="info" amount={ this.balance() } text="Balance" />
      </div>
      <RecordForm handleNewRecord={ this.addRecord } />
      <br />
      <table className="table table-bordered">
        <thead>
          <tr>
            <th>Date</th>
            <th>Title</th>
            <th>Amount</th>
            <th width="10%">Actions</th>
          </tr>
        </thead>
        <tbody>
          { this.state.records.map((record) => {
              return(
                <Record
                  key={ record.id }
                  record={ record }
                  handleDeleteRecord={ this.deleteRecord }
                  handleUpdateRecord={ this.updateRecord } />)
            })
          }
        </tbody>
      </table>
    </div>`
