class CreatePushSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :push_subscriptions, id: false do |t|
      t.string :endpoint
      t.string :p256dh
      t.string :auth
      t.references :customer, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
