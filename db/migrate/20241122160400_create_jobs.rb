class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.json :required_skills
      t.string :experience_level
      t.string :salary_range
      t.string :location
      t.integer :work_type
      t.integer :status

      t.timestamps
    end

    add_index :jobs, :status
  end
end
