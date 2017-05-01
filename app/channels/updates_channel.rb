class UpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "updates:#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
