class Course < ApplicationRecord
  belongs_to :department
  has_many :managed_courses

  validates :department_id, presence: true
  validates :d_abbr, presence: true
  validates :number, presence: true, inclusion: 0000..9999
  validates :name, presence: true
  validates :hours, presence: true, inclusion: 0..8
  validates :avg_gpa, allow_nil: true, format: { with: /\d{1}[.]\d{2}/i }
end
