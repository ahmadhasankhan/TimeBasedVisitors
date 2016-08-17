module VisitorsHelper
  def format_visitors_graph_data(visitors)
    #We can also pass this date for old dates
    #today = Time.now.strftime("%Y-%m-%d")
    data = []
    visitors.each do |visitor|
      temp_hash = {}
      temp_hash[:total] = visitor.till_now
      temp_hash[:entry] = visitor.entry
      temp_hash[:exit] = visitor.exit
      temp_hash[:event_time] = Time.at(visitor.event_time).strftime("%d-%m-%Y %H:%M:%S")
      data << temp_hash
    end
    data
  end

  def temp
    data = []
    temp_hash = {}
    temp_hash[:total] = 0
    temp_hash[:entry] = 0
    temp_hash[:exit] = 0
    temp_hash[:event_time] = Time.now.strftime("%d-%m-%Y %H:%M:%S")
    data << temp_hash
  end
end

