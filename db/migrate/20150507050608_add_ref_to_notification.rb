class AddRefToNotification < ActiveRecord::Migration
  def change
    add_reference :notifications, :admin, index: true
  end
end
