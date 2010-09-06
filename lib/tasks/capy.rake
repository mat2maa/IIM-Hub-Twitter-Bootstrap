desc "Remove capybara files"
task :capy do
  Dir.foreach("#{RAILS_ROOT}"){|file| File.delete("#{RAILS_ROOT}/"+file) if (/^capybara-.+html$/).match(file)}
end