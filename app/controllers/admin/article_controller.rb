class Admin::ArticleController < Admin::BaseController

  load_and_authorize_resource

  ActionController::Base.prepend_view_path("app/themes/#{$layout}")

  cache_sweeper :article_sweeper

  def index
    @q = Article.includes(:issue, :category).search(params[:q], :auth_object => 'admin')
    @article = Article.issued.page(params[:page]).order("date DESC").per(20)
    @nonis_article = Article.non_issued.page(params[:ni_page]).order("date DESC").per(20)
  end

  def new
    @article=Article.new
  end

  def search
    @q = Article.includes(:issue, :category).search(params[:q], :auth_object => 'admin')
    @article = @q.result(:distinct => true).page(params[:page]).order("date DESC").per(20)
  end

  def create
    @article = Article.new(params[:article])
    @article.build_ordering
    @article.ordering.cat_pos=99
    if @article.preview == "1" && @article.valid?
      show
    elsif @article.save
      redirect_to(admin_articles_path, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if params[:article][:preview] == "1" && @article.valid?
      show
    elsif @article.update_attributes(params[:article])
      redirect_to(admin_articles_path, :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to(admin_articles_path)
  end

  def show
    @article = Article.find(params[:id]) if @article.nil?
    @issue = @article.issue ||  Setting.current_issue || Issue.first
    @category = @article.category
    render "/article/issued_article", layout: $layout
  end


  def sitemap
    @articles = Article.includes(:issue, :category).where(published: true).order("created_at DESC")
    File.delete("#{Rails.root}/public/sitemap.xml") if File.exists?("#{Rails.root}/public/sitemap.xml")

    sitemap = File.new("#{Rails.root}/public/sitemap.xml", "w")
    sitemap.puts('<?xml version="1.0" encoding="utf-8"?>')
    sitemap.puts('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
    @articles.each do |article|
      sitemap.puts('<url>')
      url = article.issue_id.nil? ?  "/#{article.category_permalink}/#{article.id}-#{article.prettify_permalink}" : "/issue_#{article.issue_number}/#{article.category_permalink}/#{article.id}-#{article.prettify_permalink}"
      sitemap.puts("<loc>#{$domain}#{url}/</loc>")
      sitemap.puts("<lastmod>#{article.updated_at.strftime("%Y-%m-%d")}</lastmod>")
      sitemap.puts('</url>')
    end
    sitemap.puts('</urlset>')
    sitemap.close
    redirect_to admin_articles_url, notice: 'Sitemap was successfully created.'
  end

end

