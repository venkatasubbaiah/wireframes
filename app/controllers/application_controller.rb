class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'carrierwave/orm/activerecord'
end
