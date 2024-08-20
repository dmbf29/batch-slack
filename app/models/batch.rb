class Batch < ApplicationRecord
  has_many :messages, dependent: :destroy
end
