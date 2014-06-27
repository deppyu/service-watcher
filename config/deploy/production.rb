# encoding: utf-8
set :rails_env, "production" # defaults: production
set :application, "observice"
set :branch, "master"
set :user, "edoctor"
set :deploy_to, "/srv/#{application}"

# org.edr.im
# 此处写 ip 或 hostname，建议写 ip，防止团队成员 hostname 不同
server '92.168.10.128', :app, :web, :db, :primary => true
