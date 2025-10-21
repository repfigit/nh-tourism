class Activity < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :description, presence: true
  validates :difficulty, presence: true
end
