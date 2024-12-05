class SendGithubActivityJob < ApplicationJob
  queue_as :default

  def perform(number)
    puts "Go to Github and scrape commit activity"
    batch = Batch.find_by(number: number)
    results = FetchBatchActivityService.new(batch, Date.yesterday).call
    puts "Build a message for our app"
    puts "Send it to the app"
    CreateGithubMessageService.new(batch, results).call
  end
end


# SendGithubActivityJob.perform_later(@batch.number)
