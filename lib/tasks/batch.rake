namespace :batch do
  desc "Send Github leaderboard for 1808"
  task send_leaderboards: :environment do
    SendGithubActivityJob.perform_later(1808)
  end

end
