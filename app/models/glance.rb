class Glance < ApplicationRecord
  belongs_to :connection

  validates :question, presence: true
end
