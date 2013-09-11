class AddFieldsToGifImage < ActiveRecord::Migration
  def up
    add_column :gif_images, :team, :string
    add_column :gif_images, :date, :datetime
  end

  def down
    remove_column :gif_images, :team
    remove_column :gif_images, :date
  end
end
