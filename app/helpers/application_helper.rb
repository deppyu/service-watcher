# encoding: utf-8
require 'time'

module ApplicationHelper

  def transclate_time(date)
    date.year.to_s + '年' + date.month.to_s + '月' + date.day.to_s + '日' + "#{date.hour}:#{date.min}:#{date.sec}"
  end
end
