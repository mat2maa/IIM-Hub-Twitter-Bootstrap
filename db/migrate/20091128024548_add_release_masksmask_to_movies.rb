class AddReleaseMasksmaskToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :release_versions_mask, :integer
    add_column :movies, :release_version, :string
    
    add_column :movies, :screener_remarks_mask, :integer
    add_column :movies, :screener_remark, :string
  end

  def self.down
    remove_column :movies, :release_versions_mask
    remove_column :movies, :release_version
    
    remove_column :movies, :screener_remarks_mask
    remove_column :movies, :screener_remark
  end
end
