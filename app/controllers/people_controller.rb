class PeopleController < ApplicationController
  before_filter :ensure_login, :only => [:edit, :update, :destroy]
  before_filter :ensure_logout, :only => [:new, :create]

  def index
    @people = Person.find(:all)
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      @session = @person.sessions.create
      session[:id] = @session.id
      flash[:notice] = "Welcome #{@person.name}, you are now registered!"

      if params[:import_withings]
        redirect_to :controller => :withings, :action => :import
      else
        redirect_to(root_url)
      end
    else
      render(:action => 'new')
    end
  end

  def edit
    @person = Person.find(@user)
  end

  def update
    @person = Person.find(@user)
    if @person.update_attributes(params[:person])
      flash[:notice] = "Your account has been updated"
      redirect_to(root_url)
    else
      render(:action => 'edit')
    end
  end

  def destroy
    Person.destroy(@user)
    session[:id] = @user = nil
    flash[:notice] = "You are now unregistered"
    redirect_to(root_url)
  end

end
