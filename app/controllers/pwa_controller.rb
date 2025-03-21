class PwaController < ApplicationController
  def manifest
    if request.subdomain.include? 'team'
      @root = '/orders'
    else
      @root = '/app'
    end
  end
end