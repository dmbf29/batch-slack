class BatchesController < ApplicationController

  def github
    @batch = Batch.find(55)
    SendGithubActivityJob.perform_later(@batch.number)
    head :ok # dont show a view, we're not expecting anything to happen
  end

  def show
    @batch = Batch.find(params[:id])
    @batches = Batch.order(number: :desc)
    @message = Message.new
  end

  def edit
    @batch = Batch.find(params[:id])
  end

  def update
    @batch = Batch.find(params[:id])
    if @batch.update(batch_params)
      redirect_to batch_path(@batch)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy
    redirect_to root_path
  end

  private

  def batch_params
    params.require(:batch).permit(:number, :start_date, :end_date, :slack_channel, :data_science, :part_time)
  end
end
