class AudioPlaylist < ActiveRecord::Base  
  has_many :audio_playlist_tracks, :dependent => :destroy
  has_many :tracks, :through => :audio_playlist_tracks

  belongs_to :program  
  belongs_to :vo  
  belongs_to :airline
  belongs_to :user
	
	def audio_playlist_tracks_sorted
		#self.audio_playlist_tracks.sort_by {|a| [a.position]}
    return AudioPlaylistTrack.find(:all, :include=>[:track, {:track=>:album},{:track=>{:album=>:label}}], :conditions=>{:audio_playlist_id => self.id}, :order=>:position)
	end
	
  def total_duration_cached
    Rails.cache.fetch('AudioPlaylist.'+self.id.to_s+'.total_duration' + self.updated_at.strftime('%Y%m%d%H%M%S')){duration_from_sec total_duration}
  end
  
  
  def total_duration
    t = 0
    
  	self.audio_playlist_tracks.each do |audio_playlist_track|
			if audio_playlist_track.track.nil?
				 t+=0
			else
				t += audio_playlist_track.track.duration/1000
				t += audio_playlist_track.vo_duration.to_i if !audio_playlist_track.vo_duration.nil?			
			end
  	end

  	#duration_from_sec t
  	t
    
  end
  
  def duration_from_sec sec
    if !sec.nil?
  	
      min = sec/60
  
      sec = sec%60

      if sec < 10 :  sec = "0#{sec}"
      end 
      if sec == 0 :  sec = "00"
      end
      if min == 0 :  min = "0"
      end

      t = "#{min}:#{sec}"
    else 
      t = "0:00"
    end
    t
  end
  
end
