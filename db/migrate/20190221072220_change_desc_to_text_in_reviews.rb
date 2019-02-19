class ChangeDescToTextInReviews < ActiveRecord::Migration[5.2]
  def change
    change_column :reviews, :desc, :text
  end
end
