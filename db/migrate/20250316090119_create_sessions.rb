class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.references :cafe, null: false, foreign_key: { to_table: :cafes }
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
