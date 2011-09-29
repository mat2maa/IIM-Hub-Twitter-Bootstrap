class CreateMasterLanguages < ActiveRecord::Migration
  def self.up
    create_table :master_languages do |t|
      t.string :name

      t.timestamps
    end
        
    IIM::MOVIE_LANGUAGES.each do |language|
      MasterLanguage.create(:name => language)
    end
  end

  def self.down
    drop_table :master_languages
  end
end
