class AddAttachmentAvatarToAdmins < ActiveRecord::Migration
  def self.up
    change_table :admins do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :admins, :avatar
  end
end
