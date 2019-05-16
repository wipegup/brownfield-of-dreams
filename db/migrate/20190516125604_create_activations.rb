class CreateActivations < ActiveRecord::Migration[5.2]
  def change
    create_table :activations do |t|
      t.integer   :user_id
      t.boolean   :status, default: 0
      t.string    :email_code

      t.timestamps
    end
  end
end
