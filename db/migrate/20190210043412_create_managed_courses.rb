class CreateManagedCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :managed_courses do |t|
      t.integer :year, limit: 2
      t.integer :semester, limit: 1
      t.float :avg_gpa
      t.integer :gpa_a, limit: 1
      t.integer :gpa_b, limit: 1
      t.integer :gpa_c, limit: 1
      t.integer :gpa_d, limit: 1
      t.integer :gpa_f, limit: 1
      t.integer :gpa_w, limit: 1

      t.references :lecturer
      t.references :course
      t.timestamps
    end
  end
end
