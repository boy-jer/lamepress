class JavascriptsController < ApplicationController

  def dynamic_categories
    @categories = Category.find(:all)
  end

  def dynamic_dates
    @issues = Issue.find(:all, :order => "number DESC")
  end

  def dynamic_dates_pub
    @issues = Issue.where(published: true).order("number DESC")
    render "dynamic_dates"
  end

  def misc

  end

  def sortable_list

  end

  def date_picker

  end

  def admin_date_picker

  end

end

