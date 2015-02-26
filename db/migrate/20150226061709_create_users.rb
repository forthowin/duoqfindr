class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :role
      t.string :tier

      t.timestamp
    end
  end
end