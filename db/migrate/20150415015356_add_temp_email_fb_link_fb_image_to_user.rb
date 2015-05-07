class AddTempEmailFbLinkFbImageToUser < ActiveRecord::Migration
  def change
    add_column :users, :temp_email, :string
    add_column :users, :fb_link, :string
    add_column :users, :fb_image, :string
  end
end
