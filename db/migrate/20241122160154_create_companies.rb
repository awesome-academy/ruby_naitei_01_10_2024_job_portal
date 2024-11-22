class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.json :general_info
      t.string :website
      t.text :address

      t.timestamps
    end

    add_index :companies, :name
  end
end
