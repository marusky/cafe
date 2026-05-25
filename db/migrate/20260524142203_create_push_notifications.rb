class CreatePushNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :push_notifications do |t|
      t.string :title
      t.string :body

      t.references :push_subscription, foreign_key: true, null: false

      t.timestamps
    end
  end
end
