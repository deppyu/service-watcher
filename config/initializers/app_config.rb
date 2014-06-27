# encoding: utf-8
root = Rails.root.to_s
env = Rails.env

unless defined? APP_CONFIG
  APP_CONFIG = YAML.load_file("#{root}/config/config.yml")[env]
end

