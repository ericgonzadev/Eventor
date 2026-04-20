class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :date
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
