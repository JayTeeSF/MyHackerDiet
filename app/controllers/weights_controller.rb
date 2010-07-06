require 'csv'

class WeightsController < ApplicationController
  # GET /weights
  # GET /weights.xml
  before_filter :authenticate_user!

  def index
    @weight = Weight.new # new empty weight if user wants to create a new record

    fail 'ahhhh!'

    respond_to do |format|
      format.html do
        @graph = graph_code( 2.months.ago, '800x300' )
        @weights = Weight.paginate_all_by_user_id(current_user.id, :per_page=>15, :page => params[:page], :order => 'rec_date DESC')
      end
      format.mobile do
        @graph = graph_code( 7.days.ago, '800x300' )
        @weights = Weight.paginate_all_by_user_id(current_user.id, :per_page=>5, :page => params[:page], :order => 'rec_date DESC')
      end
      format.xml  { render :xml => @weights }
      format.csv do
        @weights = Weight.find(:all, :conditions => ["user_id = ?", current_user.id])   # get all the weights, not just this page

        csv_string = CSV.generate do |csv|
          # header row
          csv << ["rec_date", "weight", "avg_weight", "bodyfat"]

          #data rows
          @weights.each do |s|
            csv << [s.rec_date, s.weight, s.avg_weight, s.bodyfat]
          end
        end

        send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=weights.csv"
      end
    end
  end


  def graph_code( show_days, graph_size )
    weights = Weight.find(:all, :conditions => ["user_id = ?", current_user.id], :order => 'rec_date ASC')   # get all the weights, not just this page
    weightDates = ''
    weightValues_below = ''
    weightValues_above = ''
    min = 1000;
    max = 0;

    weightedDates = ''
    weighted_weights = []

    weights.each do |c|
      unless c.rec_date == nil || c.weight == nil then
        weighted_weights.push(c.weight.round);
        if weighted_weights.length > 20 then weighted_weights.shift end #remove first weight when over limit

        if c.rec_date.to_date >= show_days.to_date then
          # For each weight keep a running string for each of the lines (below average, average, above average)
          # our strings will each end with an extra comma, which will need to be chopped when appended to the full
          # google chart string
          weightDates  << '|' + c.rec_date.to_date.day.to_s
          weightedDates << c.avg_weight.to_s + ','
          
          if c.weight < c.avg_weight then
            weightValues_below << c.weight.to_s + ','
            weightValues_above << c.avg_weight.to_s  + ','
          else
            weightValues_above << c.weight.to_s + ','
            weightValues_below << c.avg_weight.to_s + ','
          end

          # Set the minimum and maximum values for the chart
          if c.weight.round < min then min = c.weight.round end
          if c.weight.round > max then max = c.weight.round end
        end
      end
    end

    # minimum should be less than all the weights
    min = min - 1

    manchart = "http://chart.apis.google.com/chart?cht=lc&chtt=MyHackerDiet.com+Weight+Chart+for+#{current_user.email}&chs=#{graph_size}&chd=t:"
    manchart_suffix = "&chco=4d89f9,c6d9fd&chds=#{min},#{max}&chbh=20&chxt=x,y&chxl=1:|#{min}|#{max-((max-min)/2)}|#{max}|0:"
    manchart_areafill = '&chm=b,0000FF,0,-1,10.0|b,80C65A,0,1,0|b,FF0000,1,2,0'

    url = manchart + weightValues_below.chop() + '|' + weightedDates.chop() + '|' + weightValues_above.chop() + manchart_suffix + weightDates + manchart_areafill

    return url
  end
  #
  # GET /weights/1
  # GET /weights/1.xml
  def show
    @weight = Weight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.mobile # show.mobile.erb
      format.xml  { render :xml => @weight }
    end
  end

  # GET /weights/new
  # GET /weights/new.xml
  def new
    @weight = Weight.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weight }
    end

  end

  # GET /weights/1/edit
  def edit
    @weight = Weight.find(params[:id])
  end

  # POST /weights
  # POST /weights.xml
  def create
    @weight = Weight.new(params[:weight])
    @weight.calc_avg_weight

    respond_to do |format|
      if @weight.save
        flash[:notice] = 'Weight was successfully created.'
        format.html { redirect_to(weights_url) }
        #format.mobile { redirect_to(root_url)  }
        format.mobile { render :action => 'edit' }
        format.xml  { render :xml => @weight, :status => :created, :location => @weight }
      else
        format.html { render :action => "new" }
        format.mobile { render :action => "index" }
        format.xml  { render :xml => @weight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weights/1
  # PUT /weights/1.xml
  def update
    @weight = Weight.find(params[:id])
    @weight.manual = 1
    @weight.calc_avg_weight

    weights_after = Weight.find_all_by_user_id(current_user.id, :conditions => ["rec_date > ?", @weight.rec_date], :order => 'rec_date ASC')
    weights_after.each do |w|
      w.calc_avg_weight
      w.save
    end

    respond_to do |format|
      if @weight.update_attributes(params[:weight])
        flash[:notice] = 'Weight was successfully updated.'
        format.html { redirect_to(weights_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weights/1
  # DELETE /weights/1.xml
  def destroy
    @weight = Weight.find(params[:id])
    @weight.destroy

    respond_to do |format|
      format.html { redirect_to(weights_url) }
      format.xml  { head :ok }
    end
  end

  def csv_import 
    @parsed_file=CSV.parse(params[:dump][:file])
    n=0
    @parsed_file.each  do |row|
      c=Weight.new
      c.rec_date=row[0]
      c.weight=row[1]
      c.bodyfat=row[3]
      c.user_id = current_user.id

      valid = true
      valid=false if c.weight == nil || c.weight == 0
      valid=false if c.bodyfat == nil || c.bodyfat == 0

      if valid && c.save
        n=n+1
        GC.start if n%50==0
      end
      flash[:notice]="CSV Import Successful,  #{n} new records added to data base"
    end

    # Recalculate the average weight
    first_weight = Weight.find_by_user_id(current_user.id, :order => 'created_at ASC')
    weights_after = Weight.find_all_by_user_id(current_user.id, :conditions => ["rec_date > ?", first_weight.rec_date], :order => 'rec_date ASC')
    weights_after.each do |w|
      w.calc_avg_weight
      w.save
    end

    redirect_to :action=>"index"
  end
end

