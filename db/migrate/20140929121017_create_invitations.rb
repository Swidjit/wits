class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :invite_code
    end
  end
end
