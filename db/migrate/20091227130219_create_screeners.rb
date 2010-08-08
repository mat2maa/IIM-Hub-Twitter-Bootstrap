class CreateScreeners < ActiveRecord::Migration
  def self.up
    create_table :screeners do |t|
      t.integer :video_id
      t.string :episode_title
      t.integer :episode_number
      t.string :location
      t.string :remarks
      t.string :remarks_other

      t.timestamps
    end
    
    add_index :screeners, :video_id
        
  end

  def self.down
    remove_index :screeners, :video_id
    
    drop_table :screeners
  end
end
