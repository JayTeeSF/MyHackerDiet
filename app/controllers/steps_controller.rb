class StepsController < ApplicationController
  require 'csv'
  # GET /steps
  # GET /steps.xml
  # GET /steps.csv
  def index
    @steps = Step.all

    genGnu()

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
      format.csv do
        csv_string = FasterCSV.generate do |csv|
          # header row
          csv << ["rec_date", "steps", "mod_steps"]

          # data rows
          @steps.each do |s|
            csv << [s.rec_date, s.steps, s.mod_steps]
          end
        end

        send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=steps.csv"
      end
    end
  end

  def genGnu
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|

        plot.terminal "png transparent nocrop enhanced size 800 600"
        #plot.ylabel "steps"
        #plot.xlabel "date"
        plot.output "public/fruity.png"
        plot.boxwidth "0.2 absolute"
        plot.style "fill solid 1.00 border -1"
        plot.style "histogram rowstacked"
        plot.style "data histograms"
        plot.xtics "border in scale 1,0.5 nomirror rotate -45 offset character 0, 0, 0"
        plot.title  "Steps for Jon Gaudette"

        x = []
        y = []
        z = []
        @steps.each do |s|
          x.push(s.rec_date)
          y.push(s.steps - s.mod_steps)
          z.push(s.mod_steps)

          puts "test: " + s.rec_date.to_s + " -> " + (s.steps - s.mod_steps).to_s + " -> " + s.mod_steps.to_s
        end
        

        plot.data << Gnuplot::DataSet.new( [x, z] ) do |ds|
          ds.using = "2:xtic(1) t 'moderate'"
        end
        plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
          ds.using = "2:xtic(1) t 'normal'"
        end
      end
    end
  end

  def genChart
    step = []
    mod_step = []
    labels = []

    @steps.each do |s|
      step << s.steps
      mod_step << s.mod_steps
      labels << s.rec_date
    end

    g = Gruff::Bar.new
    g.title="Steps Taken"
    g.data("Steps", step)
    g.data("Moderate Steps", mod_step);
    g.theme_37signals()
    #g.render_transparent_background()
    #g.render_background ('transparent')
    #g.labels = {0=>'2003', 2 => '2004', 4=>'2005'}
    g.write('public/fruity.png')
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
        format.html { redirect_to(@step) }
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
        format.html { redirect_to(@step) }
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

end
