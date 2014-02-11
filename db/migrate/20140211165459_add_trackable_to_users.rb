class AddTrackableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      ## Revert Invitable
      t.remove_references :invited_by, :polymorphic => true
      t.remove :invitation_limit, :invitation_sent_at, :invitation_accepted_at, :invitation_token

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Omniauth
      t.string :provider
      t.string :uid
    end
  end
end
