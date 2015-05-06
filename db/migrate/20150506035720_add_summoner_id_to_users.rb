class AddSummonerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :summoner_id, :integer
  end
end
