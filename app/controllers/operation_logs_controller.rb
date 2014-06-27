# encoding: utf-8
require 'time'

class OperationLogsController < ApplicationController

  layout 'application'

  def index
    date = params[:date].blank? ? 1.day.ago : Time.parse(params[:date])
    @logs = OperationLog.where(:created_at.gte => date.beginning_of_day,:created_at.lt => date.end_of_day)
  end


  private
  def params_keepers
    #params.require()
  end
end