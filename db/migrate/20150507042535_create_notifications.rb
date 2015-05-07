class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :headline
      t.string :content

      t.timestamps
    end
  end
end
