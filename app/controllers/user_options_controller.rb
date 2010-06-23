class UserOptionsController < ApplicationController
  # GET /user_options
  # GET /user_options.xml
  def index
    @user_options = UserOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_options }
    end
  end

  # GET /user_options/1
  # GET /user_options/1.xml
  def show
    @user_option = UserOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_option }
    end
  end

  # GET /user_options/new
  # GET /user_options/new.xml
  def new
    @user_option = UserOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_option }
    end
  end

  # GET /user_options/1/edit
  def edit
    @user_option = UserOption.find(params[:id])
  end

  # POST /user_options
  # POST /user_options.xml
  def create
    @user_option = UserOption.new(params[:user_option])

    respond_to do |format|
      if @user_option.save
        format.html { redirect_to(@user_option, :notice => 'UserOption was successfully created.') }
        format.xml  { render :xml => @user_option, :status => :created, :location => @user_option }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_options/1
  # PUT /user_options/1.xml
  def update
    @user_option = UserOption.find(params[:id])

    respond_to do |format|
      if @user_option.update_attributes(params[:user_option])
        format.html { redirect_to(@user_option, :notice => 'UserOption was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_options/1
  # DELETE /user_options/1.xml
  def destroy
    @user_option = UserOption.find(params[:id])
    @user_option.destroy

    respond_to do |format|
      format.html { redirect_to(user_options_url) }
      format.xml  { head :ok }
    end
  end
end
