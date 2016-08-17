class VisitorsController < ApplicationController
  before_action :set_visitor, only: [:show, :edit, :update, :destroy]

  # GET /visitors
  # GET /visitors.json
  def index
    @visitors = Visitor.all
  end

  # GET /visitors/1
  # GET /visitors/1.json
  def show
  end

  # GET /visitors/new
  def new
    @visitor = Visitor.new
  end

  # GET /visitors/1/edit
  def edit
  end

  # POST /visitors
  # POST /visitors.json
  def create
    @visitor = Visitor.new(visitor_params)

    respond_to do |format|
      if @visitor.save
        format.html { redirect_to @visitor, notice: 'Visitor was successfully created.' }
        format.json { render :show, status: :created, location: @visitor }
      else
        format.html { render :new }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visitors/1
  # PATCH/PUT /visitors/1.json
  def update
    respond_to do |format|
      if @visitor.update(visitor_params)
        format.html { redirect_to @visitor, notice: 'Visitor was successfully updated.' }
        format.json { render :show, status: :ok, location: @visitor }
      else
        format.html { render :edit }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visitors/1
  # DELETE /visitors/1.json
  def destroy
    @visitor.destroy
    respond_to do |format|
      format.html { redirect_to visitors_url, notice: 'Visitor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    #TODO: Remove the hardcoded file name
    file_path = Rails.public_path.join('visitors.csv')
    begin
      logger.info("Importing file: #{file_path}")
      @visitors = Visitor.import(file_path)
      logger.info("File imported : #{@visitors}")
      respond_to do |format|
        format.html { redirect_to visitors_url, notice: 'Imported successfully.' }
        format.json { render :index, status: :ok, location: @visitors }
      end
    rescue Exception => e
      logger.error("There was an error in importing data  #{e}")
      render json: e.message, status: :unprocessable_entity #Returining only in json
      #redirect_to root_url, alert: "Invalid CSV file format."
    end
  end

  def search
    @visitors = 0
    searched_time = params[:time]
    searched_time = parse_datetime_params(searched_time, "event_time")
    logger.info searched_time
    #Change date time to timestamp
    searched_timestamp = searched_time.to_i
    logger.info "*******************************Searched Time**********************************************"
    logger.info("Searched time is:  #{searched_time} and Timestamp is #{searched_timestamp}")
    searched_date = Time.at(searched_timestamp).strftime("%Y-%m-%d")
    result = PreProcessedDatum.where("event_time <= ? AND date(from_unixtime(event_time)) = ?", searched_timestamp, searched_date).order('event_time DESC').limit(1)
    logger.info("*******************************Got The Query Response**********************************************")
    logger.info(result)
    @visitor = result.first

    respond_to do |format|
      format.html { render :search, notice: 'Visitor was successfully created.' }
      format.json { render :search, status: :created, location: @visitor }
      format.js
    end
  end

  def graph_filter
    @visitors = PreProcessedDatum.all
    respond_to do |format|
      format.html { render :search, notice: 'Visitor was successfully created.' }
      format.json { render :search, status: :created, location: @visitor }
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitor
    @visitor = Visitor.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitor_params
    params.require(:visitor).permit(:event_type, :event_time)
  end
end
