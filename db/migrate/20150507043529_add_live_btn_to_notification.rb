class AddLiveBtnToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :live, :boolean
  end
end
