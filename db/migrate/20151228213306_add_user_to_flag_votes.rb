class AddUserToFlagVotes < ActiveRecord::Migration
  def change
    add_column :flag_votes, :user_id, :integer, :null=>:false

  end
end
