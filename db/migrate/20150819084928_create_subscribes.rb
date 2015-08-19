class CreateSubscribes < ActiveRecord::Migration
  def change
    create_table :subscribes do |t|
      t.belongs_to  :user
      t.belongs_to  :question
      t.timestamps null: false
    end

    add_index :subscribes, [:user_id, :question_id], unique: true
  end
end
