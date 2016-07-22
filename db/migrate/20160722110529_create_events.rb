class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.datetime :date_start
      t.datetime :date_finish
      t.integer :assosiate

      t.timestamps
    end
    add_reference :events, :user, index: true, foreign_key: true
  end
end
