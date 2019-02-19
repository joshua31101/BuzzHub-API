class CreateLecturers < ActiveRecord::Migration[5.2]
  def change
    create_table :lecturers do |t|
      t.string :first_name
      t.string :last_name
    
      t.index [:first_name, :last_name], unique: true
      t.timestamps
    end
  end
end
