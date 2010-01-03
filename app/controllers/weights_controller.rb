require 'csv'

class WeightsController < ApplicationController
  # GET /weights
  # GET /weights.xml
  before_filter :maintain_session_and_user
  before_filter :ensure_login


  def index
    @weight = Weight.new # new empty weight if user wants to create a new record
    @weights = Weight.paginate_all_by_person_id(@user.id, :per_page=>15, :page => params[:page], :order => 'rec_date DESC')
    
    @graph = open_flash_chart_object(1000,600, "/weight_graph.json")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weights }
      format.csv do
        @weights = Weight.find(:all, :conditions => ["person_id = ?", @user.id])   # get all the weights, not just this page

        csv_string = CSV.generate do |csv|
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

  def graph_code
    # based on this example - http://teethgrinder.cookies.uk/open-flash-chart-2/data-lines-2.php
    title = Title.new("MyHackerDiet.com Weight Chart For ME!")

    weightDates  = []
    weightValues = []

    @weights = Weight.find(:all, :conditions => ["person_id = ?", @user.id])   # get all the weights, not just this page
    @weights.each do |c|
      weightDates  << c.rec_date
      weightValues << c.weight
    end

    line = Line.new
    line.text = "Weight"
    line.width = 1
    line.colour = '#0000CD'
    line.dot_size = 0
    line.values = weightValues

    y = YAxis.new
    y.set_range(weightValues.min-5,weightValues.max+5,10)


    xl = XAxisLabels.new;
    xl.set_vertical()
    xl.set_labels(weightDates)

    x = XAxis.new
    x.set_labels(xl)

    x_legend = XLegend.new("Recorded Date")
    x_legend.set_style('{font-size: 20px; color: #000000}')

    y_legend = YLegend.new("Recorded Weight")
    y_legend.set_style('{font-size: 20px; color: #000000}')

    chart =OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x
    chart.set_bg_colour( '#FFFFFF' )

    chart.add_element(line)

    render :text => chart.to_s
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
        format.html { redirect_to(weights_url) }
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
      c.bodyfat=row[3]
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

