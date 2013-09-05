class VideosController < ApplicationController
  def new

  end

  def get_video
    @video_url = params[:video_url]
    begin
      download_url = ViddlRb.get_urls(@video_url)
    rescue ViddlRb::DownloadError => e
      puts "Could not get download url: #{e.message}"
    rescue ViddlRb::PluginError => e
      puts "Plugin blew up! #{e.message}\n" +
             "Backtrace:\n#{e.backtrace.join("\n")}"
    end
    ViddlRb.io = $stdout
    @video_name = @video_url.split("=")[1]
    File.open("public/shared/#{@video_name}.wav", "wb") do |file|
      file.write open(download_url.first).read
    end
    @video = Video.new
    @video.video_file = File.open("public/shared/#{@video_name}.wav","rb")
    @video.save
  end

  def preview

    @crop_start_time = params[:start_time]
    @crop_end_time = @crop_start_time.to_i + 7
    @video_url = params[:video_url]
    @video_name = @video_url.split("=")[1]
    @initial_video_url = "public/shared/#{@video_name}.mp4"
    @crop_url = "public/crop_videos/#{@crop_start_time}_to#{@crop_start_time+7}.mp4"
    %x(ffmpeg -sameq -ss 00:00:30.12 -t 00:00:07.0 -i  "#{Rails.root}/public/shared/test.wmv" "#{Rails.root}/public/crop_videos/test.wmv")

  end
end
