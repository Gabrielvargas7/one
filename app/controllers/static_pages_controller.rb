class StaticPagesController < ApplicationController
  def home
    @user = User.new
  end

  def help
  end
  def about
    @skip_container = true
  end
  def contact
  end
end
