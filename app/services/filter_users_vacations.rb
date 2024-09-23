class FilterUsersVacations
  def initialize(**params)
    @users = params[:users]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def call
    if @start_date.present? && @end_date.present?
      @users = @users.includes(:vacations).map do |user|
        vacations = user.vacations.overlapping(@start_date, @end_date)
        user.as_json.merge(vacations: vacations)
      end
    end
    @users
  end
end