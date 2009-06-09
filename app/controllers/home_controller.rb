class HomeController < ApplicationController
  caches_page :show
  
  def index
    set_seo_meta(nil,:keywords => @setting.meta_keywords,:desc => @setting.meta_description)
    set_nav_actived("home")

    # get fanfou messages
    if !@setting.fanfou_id.blank?
      @fanfou_msgs = Fanfou.get_home_messages(@setting.fanfou_id,5)
    end
    
    if !fragment_exist? "home/index/recent_posts"
      @recent_post = Post.find(:first,:order => "created_at desc")
    end
  end

  def show
    @page = Page.find_show(params[:slug])
    
    if not @page
      render_404
      return
    end
    set_seo_meta(@page.title)
    set_nav_actived(@page.slug)
    render :file => "pages/show", :layout => "application"
  end
  
  def share
    set_nav_actived("share")
    set_seo_meta("Google Reader 分享")
    @api_url = Share.api_url(@setting)
    @shares = Share.find_all(@setting)
  end
end
