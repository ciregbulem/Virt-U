class AddProviderIdToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :provider, :string
    add_column :identities, :uid, :string
    add_reference :identities, :user, index: true
  end
end
