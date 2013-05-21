class ReRunOmittedCallbacks < ActiveRecord::Migration
  def up
    videos = Video.where("updated_at > ?", DateTime.new(2013, 5, 12))

    videos.each do |video|
      video.meta_tidy
      video.save
    end

    movies = Movie.all

    movies.each do |movie|
      movie.in_playlists = MoviePlaylist.includes("movies")
                                        .where("movies.id=#{self.movie.id}")
                                        .collect { |playlist| playlist.id }.join(',')
      movie.save(validate: false)
    end

  end

  def down
  end
end
