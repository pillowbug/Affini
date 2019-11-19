class Tag < ApplicationRecord
  has_many :connection_tags
  has_many :connections, through: :connection_tags
end
