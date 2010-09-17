set :repository,  "jon@horder.digital-drip.com:/home/jon/git/myhackerdiet.git"
set :application, "mhd"

set :scm, :git
set :user, 'jon'
set :branch, 'master'

task :production do
  puts 'PRODUCTION DEPLOY'
  set :deploy_to, "/srv/#{application}"

  role :web, "myhackerdiet.com"                          # Your HTTP server, Apache/etc
  role :app, "myhackerdiet.com"                          # This may be the same as your `Web` server
  role :db,  "myhackerdiet.com", :primary => true # This is where Rails migrations will run
end

task :staging do
  puts 'STAGING DEPLOY'
  set :deploy_to, "/srv/rails/#{application}"

  role :web, "staging.myhackerdiet.com"                          # Your HTTP server, Apache/etc
  role :app, "staging.myhackerdiet.com"                          # This may be the same as your `Web` server
  role :db,  "staging.myhackerdiet.com", :primary => true # This is where Rails migrations will run
end



# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

