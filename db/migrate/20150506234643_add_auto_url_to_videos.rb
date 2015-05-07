class AddAutoUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :url_html, :string
  end
end
