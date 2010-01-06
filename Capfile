load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

namespace :deploy do
  task :restart, :roles => [ :app ] do
    #run "sudo mongrel_rails cluster::restart -C /srv/mhd/current/mongrel_cluster.yml --clean"
    run "thin -e production -d -s 3 -p 3200 restart -c /srv/mhd/current/"
  end
end

