class CreateCompanyFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :company_followers do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :company_followers, [:company_id, :user_id], unique: true
  end
end
