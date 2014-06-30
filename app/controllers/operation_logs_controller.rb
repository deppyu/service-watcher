# encoding: utf-8
require 'time'
require 'handler'

class OperationLogsController < ApplicationController

  layout 'application'

  def index
    date = params[:date].blank? ? 1.day.ago : Time.parse(params[:date])
    if params[:check_option]
      @logs = OperationLog.where(:created_at.gte => date.beginning_of_day,:created_at.lt => date.end_of_day).and(:check_option => params[:check_option])
    else
      @logs = OperationLog.where(:created_at.gte => date.beginning_of_day,:created_at.lt => date.end_of_day)
    end
    @options = ::AppChecks::App_checks.keys.concat(::SysChecks::Sys_checks.keys).collect{|key| [key,key]}
  end


  private
  def params_keepers
    #params.require()
  end
end