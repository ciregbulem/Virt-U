class AddRefToVideo < ActiveRecord::Migration
  def change
    add_reference :videos, :admin, index: true
  end
end
