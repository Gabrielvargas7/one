module Image::ImageNameHelper

  EXTENSION_PNG = ".png"
  EXTENSION_JPG = ".jpg"

  # this method removes extension and space and dash ("-")
  def self.fix_image_name image_name

    remove_ext = remove_image_extension image_name
    final_image = remove_space_image_name remove_ext
    final_image
  end


  def self.remove_space_image_name image_name
    image_name.downcase!
    image_name.strip!
    namesplit = image_name.split(' ').join('-')
  end


  def self.remove_image_extension image_name
    image_name.downcase!
    image_name.strip!
    # remove the extension
    name_dot = image_name.split('.')
    name = name_dot[0].strip
  end

  def no_self_fix_image_name image_name
    image_name.downcase!
    image_name.strip!
    namesplit = image_name.split(' ').join('-')
  end


end
