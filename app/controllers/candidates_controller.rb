class CandidatesController < ApplicationController
  def search
    render json: @session.search_candidates(params[:query])
  end

  def applications
    render json: @session.candidate_applications(params[:id])
  end
end
