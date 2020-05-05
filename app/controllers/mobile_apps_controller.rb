class MobileAppsController < ApplicationController
  before_action :require_authenticated_user
  before_action :require_store
  before_action :check_user_permissions
  before_action :require_mobile_app, only: [:show, :update]

  def index
    query = MobileAppsService.new(@store)
    respond_to do |format|
      format.html { @app_services = query.all }
    end
  end

  def show
    render 'show'
  end

  def create
    @app_services = MobileAppsService.new(@store).new_app(mobile_app_params)
    if @app_services.save
      render 'create'
    else
      render_errors @app_services
    end
  end

  def update
    # @mobile_app = MobileApp.find(params[:id])
    if @mobile_app.update_attributes(mobile_app_params)
      render 'create'
    else
      render_errors @mobile_app
    end
  end

  private

  def mobile_app_params
    params.require(:mobile_app).permit(:id, :name, :store_ids)
  end

  def require_store
    @store = Store.find_by(id: params[:store_id])
    render_access_forbidden unless @store
  end

  def check_user_permissions
    render_access_forbidden unless current_user.has_permissions?(@store)
  end

  def require_mobile_app
    @mobile_app = MobileApp.find_by(id: params[:id])
    render_not_found unless @app
  end
end