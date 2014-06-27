# encoding: utf-8
require 'net/ssh'

module Handler
  module HelperTool
    def self.get_app_names(app_home_path,ssh)
      app_names = ssh.exec!("ls -ad #{app_home_path}/*").split("\n").collect{|app_name| app_name.slice(/\w+$/)}
    end
  end
end

require 'app_checks'
require 'sys_checks'

# ===================
# module Checks
#   SysChecks = {}
#   AppChecks = {}
#  end
#
# def def_sys_check(name, &block)
#   Checks::SysChecks[name] = block
# end
#
# def def_app_check(name, &block)
#   Checks::AppChecks[name] = block
# end
#
# def_sys_check 'ls /srv' do |ssh|
#   d = ssh.exec!("ls /srv")
#   d.split("\n").join(";")
# end
#
# def_app_check 'latest deploy' do |ssh, app_name|
#   d = ssh.exec!("readlink /srv/#{app_name}/current")
#   File.basename(d)
# end
