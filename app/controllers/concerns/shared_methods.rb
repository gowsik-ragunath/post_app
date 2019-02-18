module SharedMethods
  extend ActiveSupport::Concern
  def pagination(model,per = 10)
    model.paginate(page: params[:page], per_page: per)
  end
end