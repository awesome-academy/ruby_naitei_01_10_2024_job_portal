class CreateCompanyReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :company_reviews do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating
      t.text :content
      t.boolean :is_anonymous
      t.integer :status

      t.timestamps
    end

    add_index :company_reviews, [:company_id, :user_id], unique: true
    add_index :company_reviews, :status
  end
end
