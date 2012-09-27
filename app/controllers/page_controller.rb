class PageController < ApplicationController

  layout $layout
  before_filter :get_issue

  def show
    if (@page = Page.where(permalink: params[:perma]).published_only.first)
      @url = page_url(params[:perma])
      render action: "#{$layout}/page"
    else
      render_404
    end
  end
end