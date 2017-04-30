@Records = React.createClass
  getInitialState: ->
    records: @props.data
  getDefaultProps: ->
    records: []
  addRecord: (record) ->
    records = @state.records.slice()
    records.push record
    @setState records: records
  deleteRecord: (record) ->
    records = @state.records.slice()
    records.splice records.indexOf(record), 1
    @replaceState records: records
  updateRecord: (record, data) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1, data]] })
    @replaceState records: records
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
