class AddGithubsToBatches < ActiveRecord::Migration[7.1]
  def change
    add_column :batches, :github_usernames, :string, array: true, default: []
  end
end
