class Visitor < ActiveRecord::Base
  require 'csv'
  #Using Enum for event type
  enum event_type: {entry: 0, exit: 1}

  #Apply Validations
  validates_presence_of :ticked_id, :event_type, :event_time
  validates_numericality_of :ticked_id, :event_time
  validates_inclusion_of :event_type, in: Visitor.event_types.keys, :message => "is incorrect, only exit and entry is acceptable"

  #Import Data
  def self.import(file)
    processed_data = {}
    current = 0
    visitors_count = 0
    CSV.foreach(file, headers: true) do |row|
      visitor_hash = row.to_hash
      type_of_event = visitor_hash['event_type'].to_sym
      #Check if event already happened
      visitor = Visitor.where(ticked_id: visitor_hash['ticked_id'], event_type: Visitor.event_types[type_of_event])
      #Persist data into DB
      self.persist_imported_data(visitor_hash, visitor)
      #Pre process data for searching
      if visitor_hash['event_type'] == "entry"
        visitors_count += 1
        self.increment(processed_data, visitor_hash, current, visitors_count)
      else
        self.decrement(processed_data, visitor_hash, current, visitors_count)
      end
      #Update current
      current = processed_data[visitor_hash['event_time']].first[:current_visitors]
    end
    PreProcessedDatum.process_data(processed_data)
  end

  private

  def self.persist_imported_data(visitor_hash, visitor)
    if visitor.count >= 1
      p 'visitor already exits, updating data'
      visitor.first.update_attributes(visitor_hash)
    else
      Visitor.create!(visitor_hash)
    end
  end

  def self.increment(processed_data, visitor_hash, current, visitors_count)
    processed_data[visitor_hash['event_time']] = event_specific_data(processed_data[visitor_hash['event_time']], current+1, visitors_count, 1, 0)
  end

  def self.decrement(processed_data, visitor_hash, current, visitors_count)
    processed_data[visitor_hash['event_time']] = event_specific_data(processed_data[visitor_hash['event_time']], current-1, visitors_count, 0, 1)
  end

  def self.event_specific_data(time_specific_data, current, visitors_count, entry, exit)
    event_based_data = []
    event_based_data_hash = {}
    event_based_data_hash[:current_visitors] = current
    event_based_data_hash[:total_visitors] = visitors_count

    #Check if value already exist
    if time_specific_data
      event_based_data_hash[:entry] = time_specific_data.first[:entry]+ entry
      event_based_data_hash[:exit] = time_specific_data.first[:exit]+ exit
    else
      event_based_data_hash[:entry] = entry
      event_based_data_hash[:exit] = exit
    end

    event_based_data << event_based_data_hash
    p event_based_data
  end

end
