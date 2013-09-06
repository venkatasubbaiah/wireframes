class VideosController < ApplicationController
  def new

  end

  def index

  end

  def get_video
    #raise params.inspect
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
    File.open("public/shared/#{@video_name}.wmv", "wb") do |file|
      file.write open(download_url.first).read
    end
    @video = Video.new
    @video.video_url = @video_url
    @video.video_file = File.open("public/shared/#{@video_name}.wmv","rb")
    @video.save

end

  def preview
    @video_url = Video.last.video_url
    if !@video_url.nil?
      crop_start_time = params[:start_time].to_i
      crop_end_time = (params[:start_time].to_i + 7)
      @video_name = @video_url.split("=")[1]
      @initial_video_url = "public/shared/#{@video_name}.wmv"
      @crop_url = "public/crop_videos/#{@video_name}_crop_#{crop_start_time}_to#{(crop_start_time.to_i) +7}.wmv"
      %x(ffmpeg -ss 00:00:"#{crop_start_time}".00 -t 00:00:07.0 -i "#{@initial_video_url}" "#{@crop_url}")
      @crop_video = CropVideo.new
      @crop_video.video_id = Video.last.id
      @crop_video.crop_video_file = File.open(@crop_url,"rb")
      @crop_video.save

    end
  end
end
