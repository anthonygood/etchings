class RemoveLargeImgUrlFromEtchings < ActiveRecord::Migration
  def up
    remove_column :etchings, :thumbnail_url
    remove_column :etchings, :large_img_url
  end

  def down
    add_column :etchings, :thumbnail_url, :string
    add_column :etchings, :large_img_url, :string
  end
end
