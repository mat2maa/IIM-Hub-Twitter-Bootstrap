class Video < ActiveRecord::Base
  validates_presence_of :programme_title
  
  has_many :screeners, :dependent => :destroy
  accepts_nested_attributes_for :screeners, :reject_if => lambda { |a| a[:episode_title].blank? }, 
           :allow_destroy => true        
           
  has_many :masters, :dependent => :destroy
  accepts_nested_attributes_for :masters, :reject_if => lambda { |a| a[:episode_title].blank? }, 
            :allow_destroy => true
                 
  has_many :video_playlist_items
  has_many :video_playlists, :through=>:video_playlist_items
     
  belongs_to :video_distributor, :class_name => "Supplier", :foreign_key => "video_distributor_id"
  belongs_to :laboratory, :class_name => "Supplier", :foreign_key => "laboratory_id"
  belongs_to :production_studio, :class_name => "Supplier", :foreign_key => "production_studio_id"
  
  belongs_to :commercial_run_time
  
  has_and_belongs_to_many :video_genres
  has_attached_file :poster, :styles => { 
                    :small => "160x237>",
                    :medium => "250x250>",
                    :large => "500x500>"},
                    :url  => "/system/posters/:id/:style/:id.:extension",
                    :path => ":rails_root/public/system/posters/:id/:style/:id.:extension",
                    :default_url => "/images/:attachment/missing_video_small.png"

  validates_attachment_size :poster, :less_than => 5.megabytes
  validates_attachment_content_type :poster, :content_type => ['image/jpeg', 'image/png']
    
  named_scope :with_language_track, lambda { |language_track| {:conditions => "language_tracks_mask & #{2**IIM::MOVIE_LANGUAGES.index(language_track.to_s)} > 0"} }
  
  
  def before_save
    # if production studio is empty, set it to the same as movie distributor supplier
    if production_studio_id.nil? && !video_distributor_id.nil?
      count_suppliers = SupplierCategory.count('supplier_id', :include => :suppliers, :conditions => ["supplier_id = ? and supplier_categories.name = ? ", video_distributor_id, "Production Studios"]) 
      self.production_studio_id = video_distributor_id if !count_suppliers.zero?
    end
    
    if laboratory_id.nil? && !video_distributor_id.nil?
      count_suppliers = SupplierCategory.count('supplier_id', :include => :suppliers, :conditions => ["supplier_id = ? and supplier_categories.name = ? ", video_distributor_id, "Laboratories"]) 
      self.laboratory_id = video_distributor_id if !count_suppliers.zero?
    end
    
    self.synopsis = self.synopsis.gsub(/(\r\n|\r|\n|\u0085|\u000C|\u2028|\u2029|\s{2,})/, ' ').strip.gsub(/(\.\s{2,})/, '. ').strip    
  end
    
  def video_genres_string
    genres = self.video_genres.collect{|genre| genre.name}
    genres.join(', ')
  end
      
  def language_tracks=(language_tracks)
    self.language_tracks_mask = (language_tracks & IIM::MOVIE_LANGUAGES).map { |r| 2**IIM::MOVIE_LANGUAGES.index(r) }.sum
  end
  
  def language_tracks
    IIM::MOVIE_LANGUAGES.reject { |r| ((language_tracks_mask || 0) & 2**IIM::MOVIE_LANGUAGES.index(r)).zero? }
  end
  
  def language_track_symbols
    language_tracks.map(&:to_sym)
  end
  
  named_scope :with_language_subtitle, lambda { |language_subtitle| {:conditions => "language_subtitles_mask & #{2**IIM::MOVIE_LANGUAGES.index(language_subtitle.to_s)} > 0"} }
    
  def language_subtitles=(language_subtitles)
    self.language_subtitles_mask = (language_subtitles & IIM::MOVIE_LANGUAGES).map { |r| 2**IIM::MOVIE_LANGUAGES.index(r) }.sum
  end
  
  def language_subtitles
    IIM::MOVIE_LANGUAGES.reject { |r| ((language_subtitles_mask || 0) & 2**IIM::MOVIE_LANGUAGES.index(r)).zero? }
  end
  
  def language_subtitle_symbols
    language_subtitles.map(&:to_sym)
  end
    
  
end
