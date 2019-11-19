class Tag < ApplicationRecord
  has_and_belongs_to_many :connections

  validates :value, presence: true, uniqueness: true

  before_save :data_cleanup

  private

  def data_cleanup
    self.value = value.strip.gsub(/\s+/, ' ').titleize if value
  end
end
