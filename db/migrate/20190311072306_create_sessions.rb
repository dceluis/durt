# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.references :issue, foreign_key: true, null: false, index: true
      t.datetime :open_at, null: false
      t.datetime :closed_at
    end
  end
end
