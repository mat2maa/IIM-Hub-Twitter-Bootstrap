class Master < ActiveRecord::Base
  include Iim

  has_many :video_master_playlist_items
  has_many :video_master_playlists, :through=>:video_master_playlist_items
    
  belongs_to :video
  validates_presence_of :episode_title
  validates_format_of :time_in, :with => /(\A[0-9]{1,2}):([0-5]?[0-9]):([0-5]?[0-9]):([0-2][0-9]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='NTSC' }
  validates_format_of :time_out, :with => /(\A[0-9]{1,2}):([0-5]?[0-9]):([0-5]?[0-9]):([0-2][0-9]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='NTSC' }
  validates_format_of :time_in, :with => /(\A[0-9]{1,2}):([0-5]?[0-9]):([0-5]?[0-9]):([0-2][0-4]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='PAL' }
  validates_format_of :time_out, :with => /(\A[0-9]{1,2}):([0-5]?[0-9]):([0-5]?[0-9]):([0-2][0-4]|[0-9])\z/, 
      :if => Proc.new { |master| master.tape_format=='PAL' }
  
  def before_save
    self.episode_title = episode_title.upcase
    
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
      self[:duration]=timecode_duration(self[:time_in],self[:time_out], fps)
    else 
      "-"
    end
  end
  
  
end
