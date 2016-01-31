class ProjectsController < ApplicationController
  before_action :authenticate_user, only: :mine

  def index
    @projects = Project.all.sort {|p| p.votes.count}.reverse
    respond_to do |format|
      format.json { render json: @projects.map(&:render_with_likes).to_json }
      format.html # shows index
    end
  end

  def mine
    respond_to do |format|
      format.json { render json: current_user.projects.map(&:render_with_likes).to_json }
    end
  end
end
