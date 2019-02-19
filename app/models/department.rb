class Department < ApplicationRecord
  has_many :courses

  validates :name, presence: true
  validates :abbr, presence: true
end
