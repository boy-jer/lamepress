class Admin::IssueController < Admin::BaseController

  load_and_authorize_resource

  def index
    @issue = Issue.pub.page(params[:page]).per(20)
		@unpub_issue = Issue.unpub.page(params[:np_page]).per(20)
  end

  def new
  	@issue=Issue.new
  end

  def create
		@issue = Issue.new(params[:issue])
    if @issue.save
      redirect_to(admin_issues_path, :notice => 'Issue was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  	@issue = Issue.find(params[:id])
  end

  def update
  	@issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      redirect_to(admin_issues_path, :notice => "The issue was successfully updated.")
    else
      render :action => "edit"
    end
  end

  def destroy
  	@issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to(admin_issues_path)
  end


  # def reproc
  #   issue = Issue.find(:all)
  #   issue.each do |iss|
  #     iss.update_attributes(:cover => File.open("/home/miza/rails/mizatron/public/phpmedia/issue_"+iss.number.to_s+"/issue_"+iss.number.to_s+".jpg"), :pdf => File.open("/home/miza/rails/mizatron/public/phpmedia/issue_"+iss.number.to_s+"/issue_"+iss.number.to_s+".pdf"))
  #     #iss.update_attributes(:cover_file
  #   end
  #   render :text => "y0"
  # end


end

