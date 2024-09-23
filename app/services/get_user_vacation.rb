class GetUserVacation
  def initialize(**params)
    @user = params[:user]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def call
    if @start_date.present? && @end_date.present?
      @user.vacations.overlapping(@start_date, @end_date)
    else
      @user.vacations.all
    end
  end
end