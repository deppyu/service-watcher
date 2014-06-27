# encoding: utf-8
module AppChecks
  App_checks = {}
end

def app_check(name,&block)
  ::AppChecks::App_checks[name] = block
end

app_check 'domain' do |ssh,app_name|
  begin
    file = ssh.exec!("grep -rl /srv/#{app_name}/ /etc/nginx")
    #return 'this app not a webserver' if file.blank?
    fail 'this app not a webserver' if file.blank?
    context = ssh.exec!("cat #{file}")
    server_names = context.scan(/server_name.+;/)
    ports = context.scan(/listen.+;/)
    [server_names,ports].to_s
  rescue Exception => ex
    ex.message
  end
end

app_check 'git store' do |ssh,app_name|
  ssh.exec!("cd /srv/#{app_name}/current 2> /dev/null && git remote -v | head -1")
end

app_check 'deploy last time' do |ssh,app_name|
  file_path = ssh.exec!("readlink /srv/#{app_name}/current")
  if file_path.blank?
     'no link dir'
  else
     File.basename(ssh.exec!("readlink /srv/#{app_name}/current"))
  end
end

app_check 'vistors in yesterday' do |ssh,app_name|
  ssh.exec!("grep -c '#{Date.today - 1}' /srv/#{app_name}/current/log/production.log")
end