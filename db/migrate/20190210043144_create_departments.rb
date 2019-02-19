class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name, limit: 50
      t.string :abbr, limit: 5

      t.timestamps
    end
  end
end
