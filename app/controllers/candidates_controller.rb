class CandidatesController < ApplicationController
  def search
    render json: @session.search_candidates(params[:query])
  end
end
