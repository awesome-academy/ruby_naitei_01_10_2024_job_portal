class CreateUserProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :user_projects do |t|
      t.references :user_profile, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :role
      t.date :start_date
      t.date :end_date
      t.json :technologies_used

      t.timestamps
    end

  end
end
