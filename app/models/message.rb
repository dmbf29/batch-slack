class Message < ApplicationRecord
  belongs_to :user
  belongs_to :batch
  after_create_commit :broadcast_message

  def broadcast_message
    # tell anyone who is listening to this message's batch channel that is been created
    broadcast_append_to "batch_#{batch.id}_messages",
                        partial: "messages/message",
                        target: "messages",
                        locals: { message: self }
  end
end
