class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :overall, limit: 1
      t.integer :difficulty, limit: 1
      t.string :desc
      t.integer :year, limit: 2
      t.integer :semester, limit: 1

      t.references :managed_course
      t.timestamps
    end
  end
end
