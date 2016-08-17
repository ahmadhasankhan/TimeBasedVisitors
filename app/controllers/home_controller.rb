class HomeController < ApplicationController
  def index
    #TODO: Add filters, don't use all
    @visitors = PreProcessedDatum.all
  end
end
