# Records
class RecordsController < ApplicationController
  before_action :find_record, only: [:destroy, :update]

  def index
    @records = Record.all
  end

  def create
    @record = Record.new(record_params)

    if @record.save
      ActionCable.server.broadcast(
        'updates:records',
        method: 'create',
        body: @record
      )
      render json: @record
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  def destroy
    #@record.destroy

    ActionCable.server.broadcast(
      'updates:records',
      method: 'delete',
      body: @record,
      uuid: params[:uuid]
    )
    head :no_content
  end

  def update
    if @record.update(record_params)
      ActionCable.server.broadcast(
        'updates:records',
        method: 'update',
        body: @record,
        uuid: params[:uuid]
      )
      render json: @record
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  private

  def find_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require(:record).permit(:title, :amount, :date)
  end
end
