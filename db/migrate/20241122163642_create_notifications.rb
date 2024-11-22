class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.boolean :is_read

      t.timestamps
    end

    add_index :notifications, :is_read
    add_index :notifications, :created_at
  end
end
