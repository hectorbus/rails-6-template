class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :key
      t.text :description
      t.integer :scope

      t.timestamps
    end
  end
end
