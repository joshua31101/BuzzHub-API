class Review < ApplicationRecord
  belongs_to :managed_course

  enum semester: [:spring, :summer, :fall]

  validates :overall, :difficulty, presence: true, inclusion: 1..5
  validates :year, presence: true, inclusion: 1990..Date.today.year
end
