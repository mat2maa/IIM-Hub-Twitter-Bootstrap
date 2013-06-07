class AddAttachmentThalesSchemaPackageToMoviePlaylists < ActiveRecord::Migration
  def self.up
    change_table :movie_playlists do |t|
      t.attachment :thales_schema_package
    end
  end

  def self.down
    drop_attached_file :movie_playlists, :thales_schema_package
  end
end
