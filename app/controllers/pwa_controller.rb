class PwaController < ApplicationController
  def manifest
    if request.subdomain.include? 'team'
      @name = 'Kaféem Admin'
      @root = '/orders'
    else
      @name = 'Kaféem'
      @root = '/app'
    end
  end
end