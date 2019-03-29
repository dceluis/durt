# frozen_string_literal: true

class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :source_id
      t.string :name, null: false
      t.boolean :active, null: false, default: false
      t.string :source, null: false

      t.timestamps
    end
  end
end
