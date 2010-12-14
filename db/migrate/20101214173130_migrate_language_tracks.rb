class MigrateLanguageTracks < ActiveRecord::Migration
  def self.up
    add_column :movies, :language_tracks, :string
    add_column :movies, :language_subtitles, :string
    add_column :videos, :language_tracks, :string
    add_column :videos, :language_subtitles, :string
            
        
    # Movie.update_all "language_tracks_mask=0", "language_tracks_mask IS NULL"
    # Movie.update_all "language_subtitles_mask=0", "language_subtitles_mask IS NULL"

    Movie.all.each do |movie|
          
          puts "movie #{movie.id}"
          movie.language_tracks = movie.old_language_tracks unless movie.language_tracks_mask.nil?
          movie.language_subtitles = movie.old_language_subtitles unless movie.language_subtitles_mask.nil?
          movie.save
        end
    
    # Video.update_all "language_tracks_mask=0", "language_tracks_mask IS NULL"
    # Video.update_all "language_subtitles_mask=0", "language_subtitles_mask IS NULL"
     
    Video.all.each do |video|
      puts "video #{video.id}"
      video.language_tracks = video.old_language_tracks unless video.language_tracks_mask.nil?
      video.language_subtitles = video.old_language_subtitles unless video.language_subtitles_mask.nil?
      video.save
    end
    
    remove_column :movies, :language_tracks_mask
    remove_column :movies, :language_subtitles_mask
    remove_column :videos, :language_tracks_mask
    remove_column :videos, :language_subtitles_mask
    
  end

  def self.down
    remove_column :movies, :language_tracks
    remove_column :movies, :language_subtitles
    remove_column :videos, :language_tracks
    remove_column :videos, :language_subtitles
    
    add_column :movies, :language_tracks_mask, :string
    add_column :movies, :language_subtitles_mask, :string
    add_column :videos, :language_tracks_mask, :string
    add_column :videos, :language_subtitles_mask, :string
  end
end
