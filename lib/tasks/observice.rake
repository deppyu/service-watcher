# encoding: utf-8
require 'handler'

namespace :observice do
  task :check => :environment do
    APP_CONFIG['server_ips'].each do |ip|

     #user,password = value.split('&')
     APP_CONFIG['pwds'].each do |pw|
        begin
          puts 'ssh connection start ==========='
            ::Net::SSH.start(ip,'edoctor',:password=>pw) do |ssh|
              SysChecks::Sys_checks.each do |name,handler|
                puts name
                puts d=handler.call(ssh)
                OperationLog.create(server_ip: ip,app_name: nil,check_option: name,data: d)
              end

             Handler::HelperTool.get_app_names('/srv',ssh).each do |app_name|
               AppChecks::App_checks.each do |name,handler|
                 puts name
                 puts r=handler.call(ssh,app_name)
                 OperationLog.create(server_ip: ip,app_name: app_name,check_option: name,data: r)
               end
             end
           end
        rescue Exception => ex
          puts "====================" + ex.message
          next
        end

     end
    end
  end

end
