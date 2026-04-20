class AddCategoryIndexToEvents < ActiveRecord::Migration[5.0]
  def change
  	add_reference :events, :category, index: true
  end
end
