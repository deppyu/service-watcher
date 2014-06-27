# -*- coding: utf-8 -*-
APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    rvm_path = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
    rvm_lib_path = File.join(rvm_path, 'lib')
    require 'rvm'
    RVM.use_from_path! APP_ROOT
  rescue LoadError
    raise "RVM ruby lib is currently unavailable."
  end
end

ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
require 'bundler/setup'

worker_processes 20
working_directory APP_ROOT

preload_app true

# we use a shorter backlog for quicker failover when busy
# 可同时监听 Unix 本地 socket 或 TCP 端口
listen "#{APP_ROOT}/tmp/course.sock", :backlog => 64
# 如果不需要使用 nginx 或 apache 做反向代理，可以直接监听端口，使用端口访问
#listen 8083, :tcp_nopush => true

# 如果为 REE，则添加 copy_on_wirte_friendly
# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# request 超时时间，超过此时间则自动将此请求杀掉，单位为秒
timeout 180

# unicorn master pid
# unicorn pid 存放路径
pid APP_ROOT + "/tmp/pids/unicorn.pid"

# unicorn 日志
stderr_path APP_ROOT + "/log/unicorn.stderr.log"
stdout_path APP_ROOT + "/log/unicorn.stdout.log"

before_fork do |server, worker|
  #defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = Rails.root + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Old master alerady dead"
    end
  end
end

after_fork do |server, worker|
  #defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
  child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end