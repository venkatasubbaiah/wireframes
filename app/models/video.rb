class Video < ActiveRecord::Base
  attr_accessible :user_id, :video_file, :crop_videos
  mount_uploader :video_file, VideoUploader
  has_many :crop_videos, :dependent => :destroy
end
