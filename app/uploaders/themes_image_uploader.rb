# encoding: utf-8

class ThemesImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  include Cloudinary::CarrierWave


  #process :convert => 'jpg'
  process :tags => ['theme_image_name']


   def public_id
     img_path = "#{model.name}-#{model.category}-#{model.color}-#{model.style}-#{model.brand}-#{model.make}-#{model.special_name}-#{model.location}"
     image_path = UploaderImageHelper.set_on_image_the_path_name_for_seo(img_path)
     name = "#{rand(0..100000)}-#{model.class.to_s.underscore}-"+image_path+"-#{mounted_as}-"

     #name = "#{rand(0..100000)}-#{model.class.to_s.underscore}-#{mounted_as}-"
     filename = File.basename(original_filename, ".*")
     filename.downcase!
     name.to_s+filename.to_s
   end

   def default_url
     asset_path("fallback/theme/" + [version_name, "default_theme.png"].compact.join('_'))
   end


  # # Choose what kind of storage to use for this uploader:
  #storage :file
  ### storage :fog
  ##
  ### Override the directory where uploaded files will be stored.
  ### This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
  #
  #  #"#{Rails.root}/private/files/#{model.id}"
  #
  #  #"#{Rails.root}/app/assets/images/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #
  #  #'public/my/upload/directory'
  #  #'app/assets/images/my/upload/directory'
  #  #"#{Rails.root.join('public', 'system', 'uploads')}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #
  #  "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #
  #
  #  #"#{CarrierWave::Uploader::Base.store_dir}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #
  #  #"images/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #
  #  #asset_path("/images/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}")
  #
  #end
  #
  def cache_dir
     #"/PATH/RAILSAPPLICATION/tmp/uploads/cache/#{model.id}"
     "#{Rails.root}/tmp/uploads/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  ##
  ## #Provide a default URL as a default if there hasn't been a file uploaded:
  ##def default_url
  ##   # For Rails 3.1+ asset pipeline compatibility:
  ##
  ##    #asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  ##    asset_path("/images/fallback/theme/default_theme.png")
  ##
  ##   #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
  ##   #"/images/fallback/theme/default_theme.png"
  ##
  ##
  ##
  ##end
  ##
  ## Process files as they are uploaded:
  ## process :scale => [200, 300]
  ##
  ## def scale(width, height)
  ##   # do something
  ## end
  #
  ## Create different versions of your uploaded files:
  #
  #version :xxx_large do
  #   process :resize_to_limit => [1000, 1000]
  #end
  #
  #version :xx_large do
  #   process :resize_to_limit => [800, 800]
  #end
  #
  #version :x_large do
  #   process :resize_to_limit => [600, 600]
  #end
  #
  #version :large do
  #   process :resize_to_limit => [400, 400]
  #end
  ##
  #version :medium do
  #   process :resize_to_limit => [200, 200]
  #end
  ##
  #version :small do
  #   process :resize_to_limit => [100,100]
  #end
  ##
  ##version :tiny do
  ##   process :resize_to_limit => [64,64]
  ##end
  ## #
  # #version :toolbar do
  # #  process :resize_to_limit => [32,32]
  # #end
  #


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
