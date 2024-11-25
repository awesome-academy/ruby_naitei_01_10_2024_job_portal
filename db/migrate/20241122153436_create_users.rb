class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :full_name
      t.string :phone
      t.date :dob
      t.boolean :is_active
      t.integer :role

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role  
  end
end
