class AddMusicbrainzId < ActiveRecord::Migration
  def self.up
    add_column :tracks, :musicbrainz_id, :text
    add_column :albums, :musicbrainz_id, :text
  end

  def self.down
    remove_column :tracks, :musicbrainz_id
    remove_column :albums, :musicbrainz_id
  end
end
