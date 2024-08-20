class MessagesController < ApplicationController
  def create
    @batch = Batch.find(params[:batch_id])
    @message = Message.new(message_params)
    @message.batch = @batch
    @message.user = current_user
    if @message.save
        redirect_to batch_path(@batch)
    else
      render "batchs/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
