class MessagesController < ApplicationController
  def create
    @batch = Batch.find(params[:batch_id])
    @message = Message.new(message_params)
    @message.batch = @batch
    @message.user = current_user
    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
            locals: { message: @message })
        end
        format.html { redirect_to batch_path(@batch) }
      end
    else
      render "batchs/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
