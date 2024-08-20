class BatchesController < ApplicationController
  def show
    @batch = Batch.find(params[:id])
    @batchs = Batch.order(number: :desc)
    @message = Message.new
  end
end
