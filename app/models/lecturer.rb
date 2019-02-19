class Lecturer < ApplicationRecord
  has_many :managed_courses

  validates :first_name, uniqueness: { scope: :last_name }
end
