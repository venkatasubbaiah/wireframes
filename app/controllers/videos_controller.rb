class VideosController < ApplicationController
  def new

  end

  def index

  end

  def get_video

    begin
      source = ViddlRb.get_urls_names(params[:video_url])
      source_url = source.first[:url]
      source_name = source.first[:name]
    rescue ViddlRb::DownloadError => e
      puts "Could not get download url: #{e.message}"
    rescue ViddlRb::PluginError => e
      puts "Plugin blew up! #{e.message}\n" +
             "Backtrace:\n#{e.backtrace.join("\n")}"
    end
    File.open("public/shared/#{source_name}", "wb") do |file|
      file.write open(source_url).read
    end
    @video = Video.new
    @video.video_url = params[:video_url]
    @video.video_file = File.open("public/shared/#{source_name}","rb")
    @video.save
  end

  def preview
    @video = Video.last

    unless @video.video_url.nil?
      crop_start_time = params[:start_time].to_i
      crop_end_time = (params[:start_time].to_i + 7)
      @video_name = @video.video_file.file.filename
      @initial_video_url = "public/shared/#{@video_name}"
      @crop_url = "public/crop_videos/crop_0#{crop_start_time}_to_0#{(crop_start_time.to_i)+7}_#{@video_name}"
      unless File.exist?(@crop_url)
        %x(ffmpeg -ss 00:00:"#{crop_start_time}".00 -t 00:00:07.0 -i "#{@initial_video_url}" "#{@crop_url}")
        @crop_video = CropVideo.new
        @crop_video.video_id = @video.id
        @crop_video.crop_video_file = File.open(@crop_url,"rb")
        @crop_video.save
      end
    end
  end
end
