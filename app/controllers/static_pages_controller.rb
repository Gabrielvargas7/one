class StaticPagesController < ApplicationController
  def home

  end

  def help
  end
  def about
    @skip_container = true
    @skip_header = true
    @skip_footer = true
  end
  def contact
  end
  def landing
    @skip_header = true
    @skip_footer = true
  end
end
