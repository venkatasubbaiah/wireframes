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

  def get_gif_details

  end

  def create_gif
    @team = params[:gif_image][:title]
    @date = params[:gif_image][:date]
    @video_name = Video.last.video_file.file.filename
    @crop_video = CropVideo.last
    @crop_video_path = @crop_video.crop_video_file.path
    tmp_path = "#{Rails.root}/frames/#{@crop_video.id}"
    %x(mkdir -p "#{tmp_path}")
    %x(cd "#{tmp_path}" && ffmpeg -i "#{@crop_video_path}" -r 5 -f image2 image-%4d.png)
    #%x(ffmpeg -i "#{@crop_video}" -vf scale=320:-1 -r 10 frames/"#{video_name}"_%03d.png)
    %x(convert -delay 5 -loop 0 "#{tmp_path}/image*.png" "Gif/#{@video_name}_#{@crop_video.id}.gif")
    @git_image = GifImage.new
    @git_image.team = @team
    @git_image.date = @date
    @git_image.video_id = @crop_video.id
    @git_image.gif_image = File.open("#{Rails.root}/Gif/#{@video_name}_#{@crop_video.id}.gif","rb")
    @git_image.save

  end
end
