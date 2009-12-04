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

    genGnu()

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

  def genGnu
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|

        plot.terminal "png transparent nocrop enhanced size 800 600"
        plot.output "public/myPlot.png"
        plot.boxwidth "0.2 absolute"
        plot.style "fill solid 1.00 border -1"
        plot.style "histogram rowstacked"
        plot.style "data histograms"
        plot.xtics "border in scale 1,0.5 nomirror rotate -45 offset character 0, 0, 0"
        plot.title  "Steps for " + @user.name

        x = []
        y = []
        z = []
        
        @steps.reverse.each do |s|
          if(s.mod_steps == nil) then
            s.mod_steps = 0
          end
          x.push(s.rec_date)
          y.push(s.steps - s.mod_steps)
          z.push(s.mod_steps)

          #puts "test: " + s.rec_date.to_s + " -> " + (s.steps - s.mod_steps).to_s + " -> " + s.mod_steps.to_s
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
