require 'csv'
require 'fastercsv'

class WeightsController < ApplicationController
  # GET /weights
  # GET /weights.xml
  before_filter :maintain_session_and_user
  before_filter :ensure_login
  
  
  def index
    @weights = Weight.paginate_all_by_person_id(@user.id, :per_page=>15, :page => params[:page], :order => 'rec_date DESC')
    gnuPlot();

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weights }
      format.csv do
        csv_string = FasterCSV.generate do |csv|
          # header row
          csv << ["rec_date", "weight"]
        
          #data rows
          @weights.each do |s|
            csv << [s.rec_date, s.weight]
          end
        end

        send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=weights.csv"
      end
    end
  end

  def gnuPlot
    @allWeights = Weight.all(:all);

    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|

        plot.terminal "png transparent nocrop enhanced size 800 600"
        plot.output "public/myWeight.png"
        #plot.xdata "time"
        plot.timefmt "'%Y-%m-%d'"
        plot.style "fill solid 1.00 noborder"
        plot.style "data lines"
        plot.format "x '%m-%d'"
        plot.title "MyHackerDiet.com Weight Chart for " + @user.name

        x = []
        y = []

        @allWeights.each do |w|
          x.push(w.rec_date)
          y.push(w.weight)
        end

        plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
          #ds.using = "2:xtic(1) lt -1 lw 2 title 'curve 1'"
          ds.using = "2:xtic(1) lt -1 lw 2 title 'weight'"
        end
      end
    end
  end


  # GET /weights/1
  # GET /weights/1.xml
  def show
    @weight = Weight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
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

    respond_to do |format|
      if @weight.save
        flash[:notice] = 'Weight was successfully created.'
        format.html { redirect_to(@weight) }
        format.xml  { render :xml => @weight, :status => :created, :location => @weight }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weights/1
  # PUT /weights/1.xml
  def update
    @weight = Weight.find(params[:id])

    respond_to do |format|
      if @weight.update_attributes(params[:weight])
        flash[:notice] = 'Weight was successfully updated.'
        format.html { redirect_to(@weight) }
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
    @parsed_file=CSV::Reader.parse(params[:dump][:file])
    n=0
    @parsed_file.each  do |row|
      c=Weight.new
      c.rec_date=row[0]
      c.weight=row[1]
      c.bodyfat=row[2]
      c.person_id = @user.id

      if c.save
        n=n+1
        GC.start if n%50==0
      end
      flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
    end
    redirect_to :action=>"index"
  end
end

