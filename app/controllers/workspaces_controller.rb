class WorkspacesController < ApplicationController
  respond_to :html, :json
  def update
    @workspace = Workspace.find(params[:id])
    if params[:workspace].present?
      
      @workspace.body = params[:workspace][:body]
      @workspace.save!
      respond_with @workspace
    else
      @workspace.body = params[:body]
      @workspace.save!
      respond_to do |format|
        format.js {render 'auto_saved'}
      end
    end
  end
end
