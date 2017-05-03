class UpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "updates:#{params[:room]}"
  end
end
