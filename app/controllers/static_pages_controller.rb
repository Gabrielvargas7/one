class StaticPagesController < ApplicationController
  def home
    @user = User.new
  end

  def help
  end
  def about

  end
  def contact
  end
  def landing
    @skip_header = true
    @skip_footer = true
  end
end
