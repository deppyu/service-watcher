set :repo_url, 'git@g.edr.im:ruby/observice.git'
set :use_sudo, false
set :deploy_timestamped, true
set :release_name, Time.now.localtime.strftime("%Y%m%d%H%M%S")
set :keep_releases, 5
set :rvm_ruby_version, "2.0.0"

set :linked_files, %w{config/config.yml config/mongoid.yml config/unicorn.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets public/system config/full_lists}


namespace :deploy do
  task :start do
    on roles(:app) do
      within release_path do
        set :rvm_path, "~/.rvm"
        execute :bundle, "exec", "unicorn_rails", "-c", File.join(release_path, "config/unicorn.rb"), "-E production", "-D"
      end
    end
  end

  task :stop do
    on roles(:app) do
      pid_file = File.join(release_path, "tmp/pids/unicorn.pid")
      execute "if [[ -e #{pid_file} ]]; then kill $(cat #{pid_file}); fi"
    end
  end

  desc 'Restart application'
  task :restart do
    invoke "deploy:stop"
    invoke "deploy:start"
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :spec_ruby_version do
    on roles(:app) do
      execute("echo rvm use 2.0.0 > #{release_path}/.rvmrc")
    end
  end

  task :copy_sync_scripts do
    on roles(:app) do
      execute("cd #{release_path}; cp -r script/sync_scripts/* ~/#{fetch(:stage)}_sync_scripts")
    end
  end

  after :finishing, 'deploy:cleanup'
  #after :finishing, :copy_sync_scripts
  after :finishing, 'deploy:spec_ruby_version'
end


