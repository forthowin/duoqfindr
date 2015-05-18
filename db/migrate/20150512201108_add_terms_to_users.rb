class AddTermsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms, :integer
  end
end
