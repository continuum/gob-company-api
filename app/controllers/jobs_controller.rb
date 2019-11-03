class JobsController < ApplicationController
  def active
    render json: @session.active_jobs
  end

  def closed
    render json: @session.closed_jobs
  end

  def show
    render json: @session.job(request.fullpath)
  end
    
end
