desc "Remove capybara files"
task :capy do
  Dir.foreach("#{Rails.root}"){|file| File.delete("#{Rails.root}/"+file) if (/^capybara-.+html$/).match(file)}
end