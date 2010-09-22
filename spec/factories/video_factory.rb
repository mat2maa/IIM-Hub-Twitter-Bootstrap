Factory.sequence :episode_title do |n|
  "the episode title #{n}" 
end

Factory.sequence :programme_title do |n|
  "the video title #{n}" 
end

Factory.sequence :video_type do |n|
  "the video title #{Video::VIDEO_TYPES[n%(Video::VIDEO_TYPES.count - 1)]}" 
end

Factory.sequence :run_time_minutes do |n|
  n + 5
end

Factory.sequence :supplier_name do |n|
  "supplier #{n}" 
end

Factory.define :supplier do |record|
  record.company_name Factory.next :supplier_name
end

Factory.define :production_studio, :class => Supplier do |record|
  record.company_name Factory.next :supplier_name

  class << record
      def default_category
          @default_category ||= SupplierCategory.find_by_name('Production Studios')
      end
  end
  record.supplier_category { record.default_category }

end

Factory.define :commercial_run_time do |record|
  record.minutes Factory.next :run_time_minutes
end

Factory.define :video do |record|
  record.programme_title Factory.next :programme_title
  record.foreign_language_title Factory.next :programme_title
  record.video_type Factory.next :video_type
  record.production_year '2001'
  record.episodes_available 20
  record.synopsis {Faker::Lorem.paragraph}
  record.trailer_url 'http://test'
  record.language_tracks ['En']
  record.language_subtitles ['En']
  record.association :commercial_run_time, :factory => :commercial_run_time
end

Factory.define :master do |record|
  record.episode_title Factory.next :episode_title
  record.association :video, :factory => :video  
end

Factory.define :screener do |record|
  record.episode_title Factory.next :episode_title
  record.association :video, :factory => :video
end