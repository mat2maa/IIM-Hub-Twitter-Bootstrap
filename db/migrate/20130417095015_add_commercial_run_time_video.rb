class AddCommercialRunTimeVideo < ActiveRecord::Migration
  def up
    create_table :commercial_run_times_videos, :id => false, :force => true do |t|
      t.integer :commercial_run_time_id
      t.integer :video_id

      t.timestamps
    end
  end

  def down
    drop_table :commercial_run_times_videos
  end
end