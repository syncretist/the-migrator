# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{scitent@10.1.10.241} # scideainternal server
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '10.1.10.241', user: 'scitent', roles: %w{web app}, my_property: :my_value

set :deploy_to, '/var/www/utils/the-migrator'
set :shared_path, "#{deploy_to}/shared"
set :user, 'scitent'

# RVM bootstrap
set :rvm_ruby_version, '1.9.3-p0@the-migrator'
set :bundle_bins, fetch(:bundle_bins, []).push('foreman')

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')

      # eventually switch to: http://railscoder.com/foreman-and-capistrano-setup-on-ubuntu/
       execute "kill -9 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})"
       within "/var/www/utils/the-migrator/currentco" do
         execute :foreman, 'start'
       end
       #execute "cd #{deploy_to}/current && bundle exec foreman start"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :utility do

  desc "Check for proper remote server access"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  desc "Check if agent forwarding is working"
  task :ssh_forwarding do
    on roles(:all) do |h|
      if test("env | grep SSH_AUTH_SOCK")
        info "Agent forwarding is up to #{h}"
      else
        error "Agent forwarding is NOT up to #{h}"
      end
    end
  end

end

#namespace :foreman do
#
#  desc "Export the Procfile to Ubuntu's upstart scripts"
#  task :export do
#    on roles(:app) do
#      run "cd /var/www/utils/the-migrator && foreman export upstart /etc/init -a the-migrator -u scitent -l /var/the-migrator/log"
#    end
#  end
#
#  desc "Start the application services"
#  task :start do
#    on roles(:app) do
#      run "#{sudo} service #{application} start"
#    end
#  end
#
#  desc "Stop the application services"
#  task :stop do
#    on roles(:app) do
#      run "#{sudo} service #{application} stop"
#    end
#  end
#
#  desc "Restart the application services"
#  task :restart do
#    on roles(:app) do
#      run "#{sudo} service #{application} start || #{sudo} service #{application} restart"
#    end
#  end
#end


