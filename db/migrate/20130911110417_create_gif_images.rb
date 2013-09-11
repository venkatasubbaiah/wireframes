class CreateGifImages < ActiveRecord::Migration
  def change
    create_table :gif_images do |t|
      t.string :gif_image
      t.integer :video_id
      t.timestamps
    end
  end
end
