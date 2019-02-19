class ManagedCourse < ApplicationRecord
  belongs_to :lecturer
  belongs_to :course
  has_many :reviews

  validates :lecturer_id, :course_id, presence: true
  validates :year, allow_blank: true, inclusion: 1990..Date.today.year
  validates :avg_gpa, allow_nil: true, format: { with: /\d{1}[.]\d{2}/i }
end
