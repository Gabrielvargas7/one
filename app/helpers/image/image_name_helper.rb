module Image::ImageNameHelper

  def self.fix_image_name image_name
    image_name.downcase!
    image_name.strip!
    namesplit = image_name.split(' ').join('-')
  end

end
