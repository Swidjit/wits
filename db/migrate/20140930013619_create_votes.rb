class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :voteable, polymorphic: true
      t.string :vote
      t.belongs_to :user
      t.timestamps
    end
  end
end
