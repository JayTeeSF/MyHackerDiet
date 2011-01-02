class PublicController < ApplicationController
  # GET /public/1
  # GET /public/1.xml
  def show
    @user = User.find_by_public_id(params[:id])

    if @user.nil? or (not @user.public?)
      redirect_to( root_url, :notice => 'User does not exist or is not public' )
    else
      @graph_week = @user.graph_code( 'Last Week', 1.week.ago, '400x150' )
      @graph_two_weeks = @user.graph_code( 'Last 2 Weeks', 2.weeks.ago, '400x150' )
      @graph_two_months = @user.graph_code( 'Last 2 Months', 2.months.ago, '400x150' )
      @graph_three_months = @user.graph_code( 'Last 3 Months', 3.months.ago, '400x150' )

      @graph_week_big = @user.graph_code( 'Last Week', 1.week.ago, '800x300' )
      @graph_two_weeks_big = @user.graph_code( 'Last 2 Weeks', 2.weeks.ago, '800x300' )
      @graph_two_months_big = @user.graph_code( 'Last 2 Months', 2.months.ago, '800x300' )
      @graph_three_months_big = @user.graph_code( 'Last 3 Months', 3.months.ago, '800x300' )

      @weights = Weight.paginate_all_by_user_id(@user.id, :per_page=>30, :page => params[:page], :order => 'rec_date DESC')

      respond_to do |format|
        format.html
      end
    end
  end
end
