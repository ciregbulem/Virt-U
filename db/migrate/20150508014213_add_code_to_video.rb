class AddCodeToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :code, :text
  end
end
