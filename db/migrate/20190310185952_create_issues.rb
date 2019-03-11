class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.string :key, null: false
      t.string :source, null: false
      t.text :summary, null: false
      t.integer :estimate
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
