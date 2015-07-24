class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references  :user, index: true
      t.string      :provider
      t.string      :uid
      t.string      :email, index: true
      t.string      :confirmation_token, index: true, uniq: true
      t.boolean     :confirmation, default: false, index: true
      t.timestamps null: false
    end

    add_index :authorizations, [:provider, :uid]
  end
end
