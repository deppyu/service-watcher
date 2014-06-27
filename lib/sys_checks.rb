# encoding: utf-8
module SysChecks
  Sys_checks = {}
end

def check_sys(name,&block)
  ::SysChecks::Sys_checks[name] = block
end

check_sys 'peek_srv' do |ssh|
  d = ssh.exec!("ls /srv")
  d.split("\n").join(" ")
end

check_sys 'device_space' do |ssh|
  d = ssh.exec!("df -h")
end

