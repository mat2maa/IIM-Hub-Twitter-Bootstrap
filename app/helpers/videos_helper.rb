module VideosHelper
  def fields_for_screener(screener, &block)
    prefix = screener.new_record? ? 'new' : 'existing'
    fields_for("video[#{prefix}_screener_attributes][]", screener, &block)
  end

  def add_screener_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :screeners, :partial => 'screener', :object => Screener.new 
    end 
  end
  
  def duplicate_screener_link(name, id) 
    #screener = Screener.new
    #screener.episode_title = "test"
    #link_to_function name do |page| 
    link_to_function name do |page|
      page.insert_html :bottom, :screeners, "test", :object => Screener.new, :html_options =>[:id => 3]
    end 
  end

  def fields_for_master(master, &block)
    prefix = master.new_record? ? 'new' : 'existing'
    fields_for("video[#{prefix}_master_attributes][]", master, &block)
  end

  def add_master_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :masters, :partial => 'master', :object => Master.new 
    end 
  end
  
end