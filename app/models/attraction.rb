class Attraction < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :category, presence: true
end
