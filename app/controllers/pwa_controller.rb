class PwaController < ApplicationController
  def manifest
    if request.subdomain.include? 'team'
      @name = 'TAMcafé Admin'
      @root = '/orders'
    else
      @name = 'TAMcafé'
      @root = '/app'
    end
  end
end