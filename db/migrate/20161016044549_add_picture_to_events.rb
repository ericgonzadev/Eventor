class AddPictureToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :picture, :string
  end
end
