# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'template'
# TODO change repo
set :repo_url, 'git@example.com:me/my_repo.git'
set :rails_env, :production

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# require password
puts "server password?"
set :password, STDIN.noecho(&:gets).chomp

set :ssh_options, {
  # keys: %w(/home/rlisowski/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(password),
  password: fetch(:password)
}
namespace :deploy do

  desc 'link log and tmp to shared folder'
  after :publishing, :link_log_and_tmp do
    # on roles(:app) do
    #   execute :rm, '-rf', release_path.join('log')
    #   execute :ln, '-s', shared_path.join('log'), release_path.join('log')
    #   execute :ln, '-s', shared_path.join('tmp'), release_path.join('tmp')
    # end
  end

  desc 'copy unicorn config'
  after :link_log_and_tmp, :copy_unicorn_config do
    # on roles(:app), in: :sequence, wait: 5 do
    #   execute :mkdir, '-p', release_path.join('config', 'unicorn')
    #   execute :cp, shared_path.join('config', 'unicorn.rb'), release_path.join('config', 'unicorn', "#{fetch(:rails_env)}.rb")
    # end
  end

  after :copy_unicorn_config, 'unicorn:legacy_restart'

  before :migrate, :copy_db_config do
    # on roles(:web) do
    #   execute :cp, shared_path.join('config', 'database.yml'), release_path.join('config', 'database.yml')
    # end
  end
  after :copy_db_config, :migrate

end
