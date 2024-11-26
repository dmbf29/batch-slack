class Message < ApplicationRecord
  belongs_to :user
  belongs_to :batch
  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "batch_#{batch.id}_messages",
                        partial: "messages/message",
                        target: "messages",
                        locals: { message: self }
  end
end
