class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :number, limit: 2
      t.string :d_abbr, limit: 5
      t.string :name
      t.integer :hours, limit: 1
      t.text :desc
      t.float :avg_gpa
      t.integer :gpa_a, limit: 1
      t.integer :gpa_b, limit: 1
      t.integer :gpa_c, limit: 1
      t.integer :gpa_d, limit: 1
      t.integer :gpa_f, limit: 1
      t.integer :gpa_w, limit: 1

      t.references :department
      t.timestamps
    end
  end
end
