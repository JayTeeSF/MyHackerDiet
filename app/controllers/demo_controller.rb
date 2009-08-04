class DemoController < ApplicationController
  def index
  end

  def say_when
    render :text => "<p>The time is <b>" + DateTime.now.to_s + "</b></p>"
  end
end

