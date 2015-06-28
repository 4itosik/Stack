class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer     :like
      t.belongs_to  :user
      t.references  :voteable, polymorphic: true
      t.timestamps null: false
    end

    add_index :votes, [:user_id, :voteable_id, :voteable_type], unique: true
  end
end
