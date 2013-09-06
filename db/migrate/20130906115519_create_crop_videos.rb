class CreateCropVideos < ActiveRecord::Migration
  def change
    create_table :crop_videos do |t|
      t.string :crop_video_file
      t.integer :video_id
      t.timestamps
    end
  end
end
