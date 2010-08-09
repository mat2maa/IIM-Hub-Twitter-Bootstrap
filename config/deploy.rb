set :runner, "iim"
set :use_sudo, false

# =============================================================================
# CUSTOM OPTIONS
# =============================================================================
set :user, "iim"
set :application, "iim"
set :domain, "173.45.228.232"
set :alias, %{ iim2.audioreload.com }

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# =============================================================================
# DATABASE OPTIONS
# =============================================================================
 set :rails_env,       "production"

# =============================================================================
# DEPLOY TO
# =============================================================================
set :port, 8000
set :deploy_to, "/home/#{user}/public_html/#{application}"
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions

# =============================================================================
# REPOSITORY
# =============================================================================
set :scm, :git
set :deploy_via, :remote_cache
set :repository, "ssh://iim@#{domain}:8000/home/#{user}/git/iim.git"
#set :repository, "/home/#{user}/git/iim.git"
set :branch, "master"

# =============================================================================
# SSH OPTIONS
# =============================================================================

default_run_options[:pty] = true
set :app_server, "173.45.228.232"
ssh_options[:paranoid] = false
ssh_options[:keys] = %w(/Users/angela/.ssh/id_rsa)
ssh_options[:port] = 8000

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Reset Movies"
  task :reset_movies do
    run "rake db:reset_movies RAILS_ENV=production"
  end
  
end

after "deploy", "deploy:cleanup"
