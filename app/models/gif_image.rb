class GifImage < ActiveRecord::Base
  attr_accessible :gif_image, :video_id, :team, :date
  belongs_to :video
  mount_uploader :gif_image, VideoUploader
end
