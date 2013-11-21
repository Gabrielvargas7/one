class StaticPagesController < ApplicationController
  def home

  end

  def help
  end
  def about
    @skip_container = true
    @skip_header = false
    @skip_footer = false
  end
  def contact
  end
  def landing
    @skip_header = true
    @skip_footer = true
  end
end
