class Master < ActiveRecord::Base
  include TimeUtils

  has_many :video_master_playlist_items
  has_many :video_master_playlists, :through=>:video_master_playlist_items
  belongs_to :video, :counter_cache => true
  
  accepts_nested_attributes_for :video
    
  #default_scope :order => 'location, episode_number'

  attr_accessible :id, :duration, :created_at, :updated_at, :in_playlists, :active, :video_attributes, :video_id,
                  :episode_title, :episode_number, :tape_media, :tape_format, :tape_size, :video_subtitles_1,
                  :video_subtitles_2, :synopsis, :language_track_1, :language_track_2, :language_track_3,
                  :language_track_4, :aspect_ratio, :location, :time_in, :time_out

  attr_protected :id

  validates_presence_of :episode_title
  #PAL 25 fps, NTSC 30 fps
  validates_format_of :time_in, :with => /\A[0-9]+:([0-5]?[0-9]|[0-9]):([0-5]?[0-9]|[0-9]):([0-1][0-9]|2[0-9]|0[0-9]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='NTSC' }
  validates_format_of :time_out, :with => /\A[0-9]+:([0-5]?[0-9]|[0-9]):([0-5]?[0-9]|[0-9]):([0-1][0-9]|2[0-9]|0[0-9]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='NTSC' }
  validates_format_of :time_in, :with => /\A[0-9]+:([0-5]?[0-9]|[0-9]):([0-5]?[0-9]|[0-9]):([0-1][0-9]|2[0-4]|0[0-9]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='PAL' }
  validates_format_of :time_out, :with => /\A[0-9]+:([0-5]?[0-9]|[0-9]):([0-5]?[0-9]|[0-9]):([0-1][0-9]|2[0-4]|0[0-9]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='PAL' }
  
  def before_save
    self.episode_title = episode_title.upcase unless episode_title.nil?
  end
  
  def time_in=(the_time)
    self[:time_in] = timecode_format(the_time)
  end
    
  def time_out=(the_time)
    self[:time_out] = timecode_format(the_time)
  end
  
  def duration
    if self[:tape_format]=='PAL'
      fps = 25
    else 
      fps = 30
    end

    if !self[:time_in].nil? && !self[:time_out].nil?
      self[:duration] = timecode_duration(self[:time_in], self[:time_out], fps)
    else 
      "-"
    end
  end
  
  def duration_in_seconds
    convert_timecode_to_seconds(self.duration)
  end
  
  def video_genres_string
    genres = self.video_genres.collect{|genre| genre.name}
    genres.nil? ? "" : genres.join(', ')
  end
  
end
