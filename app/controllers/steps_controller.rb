class StepsController < ApplicationController
  require 'csv'
  # GET /steps
  # GET /steps.xml
  # GET /steps.csv
    before_filter :maintain_session_and_user
    before_filter :ensure_login
  def index
    @steps = Step.paginate_all_by_person_id(@user.id, :per_page => 30, :page => params[:page], :order => 'rec_date DESC')
    @step = Step.new

    @graph = open_flash_chart_object(800,400, "/step_graph")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
      format.csv do
        @steps = Step.find(:all, :conditions => ["person_id = ?", @user.id], :order => "rec_date");
        csv_string = FasterCSV.generate do |csv|
          # header row
          csv << ["rec_date", "steps", "mod_steps", "mod_min"]

          # data rows
          @steps.each do |s|
            csv << [s.rec_date, s.steps, s.mod_steps, s.mod_min]
          end
        end

        send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=steps.csv"
      end
    end
  end

  def graph_code
    # based on this example - http://teethgrinder.cookies.uk/open-flash-chart-2/data-lines-2.php
    title = Title.new("MyHackerDiet.com Steps Chart For ME!")

    chart =OpenFlashChart.new
    recDates  = []
    totalSteps = []

    stack = BarStack.new
    #stack.set_keys( ['hi', 'bye'] )
    @steps = Step.find(:all, :conditions => ["person_id = ? and rec_date between ? and ?", @user.id, 1.month.ago.to_s, Date.today], :order => "rec_date DESC")   # get all the weights, not just this page
    @steps.each do |c|
      recDates  << c.rec_date
      totalSteps << c.steps

      stack.append_stack ( [ c.mod_steps, c.steps-c.mod_steps ])

    end

    chart.add_element(stack)

    y = YAxis.new
    y.set_range(0,totalSteps.max+5,500)


    xl = XAxisLabels.new;
    xl.set_vertical()
    xl.set_labels(recDates)

    x = XAxis.new
    x.set_labels(xl)

    x_legend = XLegend.new("Recorded Date")
    x_legend.set_style('{font-size: 20px; color: #000000}')

    y_legend = YLegend.new("Steps Taken")
    y_legend.set_style('{font-size: 20px; color: #000000}')

    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x
    chart.set_bg_colour( '#FFFFFF' )

    render :text => chart.to_s
  end


  def gnuPlot
    @allWeights = Weight.all(:all);
    weights = []

    @allWeights.each do |s|
      weights << s.weight
    end


  end

   


  # GET /steps/1
  # GET /steps/1.xml
  def show
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = Step.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    @step = Step.new(params[:step])

    respond_to do |format|
      if @step.save
        flash[:notice] = 'Step was successfully created.'
        format.html { redirect_to(steps_url) }
        format.xml  { render :xml => @step, :status => :created, :location => @step }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    @step = Step.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        flash[:notice] = 'Step was successfully updated.'
        format.html { redirect_to(steps_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = Step.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to(steps_url) }
      format.xml  { head :ok }
    end
  end

  def csv_import 
    @parsed_file=CSV::Reader.parse(params[:dump][:file])
    n=0
    @parsed_file.each  do |row|
      c=Step.new
      c.rec_date=row[0]
      c.steps=row[1]
      c.mod_steps=row[2]
      c.mod_min=row[3]
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
