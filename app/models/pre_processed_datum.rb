class PreProcessedDatum < ActiveRecord::Base

  def self.day_wise_visitors(today)
    self.where("date(from_unixtime(event_time)) = ?", today)
  end

  def self.process_data(processed_data)
    processed_data.each do |data|
      p "********************Iterating processed_data: #{data} *****************************"
      #Prepare Hash to save in DB
      pre_processed_hash = {}
      pre_processed_hash[:event_time] = data.first
      unless data.last.blank?
        pre_processed_hash[:current_visitors] = data.last.first[:current_visitors].to_i
        pre_processed_hash[:till_now] = data.last.first[:total_visitors].to_i
        pre_processed_hash[:entry] = data.last.first[:entry].to_i
        pre_processed_hash[:exit] = data.last.first[:exit].to_i
      end

      self.persist_data(pre_processed_hash)
    end
  end

  private

  def self.persist_data(pre_processed_hash)
    processed_date = self.where(event_time: pre_processed_hash[:event_time])
    if processed_date.count >= 1
      p "*********************Updating pre processed data: #{pre_processed_hash}**********************************"
      processed_date.first.update_attributes(pre_processed_hash)
    else
      p "*********************Inserting pre processed data: #{pre_processed_hash}**********************************"
      PreProcessedDatum.create!(pre_processed_hash)
    end
  end

end
