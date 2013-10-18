# encoding: utf-8

class ItemsImageGrayUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper


  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  include Cloudinary::CarrierWave

  #process :convert => 'jpg'
  process :tags => ['item_image_name_gray']


  def public_id
    img_path = "#{model.name}"
    image_path = UploaderImageHelper.set_on_image_the_path_name_for_seo(img_path)
    name = "#{rand(0..100000)}-#{model.class.to_s.underscore}-"+image_path+"-#{mounted_as}-"

    #name = "#{rand(0..100000)}-#{model.class.to_s.underscore}-#{mounted_as}-"
    filename = File.basename(original_filename, ".*")
    filename.downcase!
    name.to_s+filename.to_s
  end

  def default_url
    asset_path("fallback/item/" + [version_name, "default_item.png"].compact.join('_'))
  end

  def cache_dir
    #"/PATH/RAILSAPPLICATION/tmp/uploads/cache/#{model.id}"
    "#{Rails.root}/tmp/uploads/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  # Choose what kind of storage to use for this uploader:
  #storage :file
  ## storage :fog
  #
  ## Override the directory where uploaded files will be stored.
  ## This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
  #  "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

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
