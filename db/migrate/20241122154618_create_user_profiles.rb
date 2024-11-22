class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio
      t.integer :gender
      t.string :current_address
      t.text :work_experience
      t.text :education
      t.json :skills
      t.string :expected_salary

      t.timestamps
    end

  end
end
