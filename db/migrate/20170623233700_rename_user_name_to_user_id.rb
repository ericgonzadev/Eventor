class RenameUserNameToUserId < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :user_name, :user_id
  end
end
