# encoding: utf-8
class OperationLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :server_ip,type: String # 被观察主机ip
  field :app_name, type: String # application名称
  field :check_option, type: String # 检查项名称
  #field :shell_command, type: String # 操作命令
  field :data,type: String #操作结果
end