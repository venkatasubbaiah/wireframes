class CropVideo < ActiveRecord::Base
  attr_accessible :crop_video_file
  belongs_to :video
  mount_uploader :crop_video_file, VideoUploader
end
