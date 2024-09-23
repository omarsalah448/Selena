class GetVacations
  def initialize(**params)
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def call
    if @start_date.present? && @end_date.present?
      Vacation.overlapping(@start_date, @end_date)
    else
      Vacation.all
    end
  end
end