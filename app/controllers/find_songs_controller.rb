class FindSongsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def find_tracks

    conditions = ""
    if !params['min_dur_min'].empty? || !params['min_dur_sec'].empty?
      tot_dur = dur_to_ms params['min_dur_min'],
                          params['min_dur_sec']
      conditions = "duration > #{tot_dur}"
    end
    if !params['max_dur_min'].empty? || !params['max_dur_sec'].empty?
      if conditions != ""
        conditions += " AND "
      end
      tot_dur = dur_to_ms params['max_dur_min'],
                          params['max_dur_sec']
      conditions += "duration < #{tot_dur}"

    end

    if params['title'].strip.length > 0

      @tracks = Track.search(params['title'],
                             %w(tracks.title_original tracks.title_english tracks.artist_original tracks.artist_english labels.name),
                             {conditions: conditions,
                              from: '(tracks left join albums on albums.id=tracks.album_id) left join labels on albums.label_id=labels.id',
                              select: 'tracks.*'})

    end
  end

  def dur_to_ms(min,
      sec)
    dur = (min.to_i * 60000) + (sec.to_i * 1000)
  end
end
