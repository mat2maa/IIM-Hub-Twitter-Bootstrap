class ReRunOmittedCallbacks < ActiveRecord::Migration
  def up
    # before_save
    movies = Movie.where("updated_at > ?", DateTime.new(2013, 5, 12))
    movies.each do |movie|
      movie.meta_tidy
      movie.save
    end

    videos = Video.where("updated_at > ?", DateTime.new(2013, 5, 12))
    videos.each do |video|
      video.meta_tidy
      video.save
    end

    masters = Master.where("updated_at > ?", DateTime.new(2013, 5, 12))
    masters.each do |master|
      master.uppercase_title
      master.save
    end

    screeners = Screener.where("updated_at > ?", DateTime.new(2013, 5, 12))
    screeners.each do |screener|
      screener.uppercase_title
      screener.save
    end

    # after_save, before_destroy
    movies = Movie.all
    movies.each do |movie|
      movie.in_playlists = MoviePlaylist.includes("movies")
                                        .where("movies.id=#{movie.id}")
                                        .collect { |playlist| playlist.id }.join(',')
      movie.save(validate: false)
    end

    videos = Video.all
    videos.each do |video|
      video.in_playlists = VideoPlaylist.includes("videos")
                                        .where("videos.id=#{video.id}")
                                        .collect { |playlist| playlist.id }.join(',')
      video.save(validate: false)
    end

    masters = Master.all
    masters.each do |master|
      master.in_playlists = VideoMasterPlaylist.includes("masters")
                                        .where("masters.id=#{master.id}")
                                        .collect { |playlist| playlist.id }.join(',')
      master.save(validate: false)
    end

    screeners = Screener.all
    screeners.each do |screener|
      screener.in_playlists = ScreenerPlaylist.includes("screeners")
                                              .where("screeners.id=#{screener.id}")
                                              .collect{|playlist| playlist.id}.join(',')
      screener.save(validate: false)
    end

  end

  def down
  end
end
