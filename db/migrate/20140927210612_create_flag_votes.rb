class CreateFlagVotes < ActiveRecord::Migration
  def change
    create_table :flag_votes do |t|
      t.belongs_to :post
      t.string :vote
    end
  end
end
