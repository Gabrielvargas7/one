module UploaderImageHelper


  def self.set_on_image_the_path_name_for_seo(img_path)

      image_path = img_path[0, 100]


      #remove all non- alphanumeric character (expect dashes '-')
      image_path = image_path.gsub(/[^0-9a-z -]/i, ' ')

      #remplace the empty space for one dash by word
      image_path.downcase!
      image_path.strip!
      image_path_split = image_path.split(' ').join('-')
      image_path_split

  end



end
