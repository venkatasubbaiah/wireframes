class Video < ActiveRecord::Base
  attr_accessible :user_id, :video_file
  mount_uploader :video_file, VideoUploader
end
