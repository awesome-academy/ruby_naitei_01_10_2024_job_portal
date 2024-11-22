class CreateUserSocialLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_social_links do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :platform
      t.string :url

      t.timestamps
    end

    add_index :user_social_links, :platform
  end
end
