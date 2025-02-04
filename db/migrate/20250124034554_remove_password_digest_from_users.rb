class RemovePasswordDigestFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :is_active, :boolean
  end
end
