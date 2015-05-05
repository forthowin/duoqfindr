class AddAccountTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_token, :string
  end
end
