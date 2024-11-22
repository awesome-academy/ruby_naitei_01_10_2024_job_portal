class CreateInterviewProcesses < ActiveRecord::Migration[7.0]
  def change
    create_table :interview_processes do |t|
      t.references :application, null: false, foreign_key: true
      t.integer :stage_number
      t.integer :stage_type
      t.datetime :interview_time
      t.string :interview_location
      t.integer :interview_type
      t.string :interviewer_name
      t.integer :status
      t.text :feedback
      t.integer :rating
      t.integer :result

      t.timestamps
    end

    add_index :interview_processes, :status
  end
end
