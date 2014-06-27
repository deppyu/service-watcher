# encoding: utf-8
require 'time'

class OperationLogsController < ApplicationController

  layout 'application'

  def index
    date = Time.parse(params[:date]) || Time.now - 1.day
    @logs = OperationLog.where(:created_at.gte => date.beginning_of_day,:created_at.lt => date.end_of_day)
  end


  private
  def params_keepers
    #params.require()
  end
end