require 'json'

class ProjectController < ApplicationController
  before_action :ensure_json_request
  before_action :authenticate_user, except: :show
  before_action :load_project, only: [:show, :update, :destroy, :vote, :unvote]
  skip_before_action :verify_authenticity_token

  # Not supported...
  def index
    render nothing: true, status: 404
  end

  def show
    render json: @project.render_with_likes.to_json
  end

  def update
    if @project.user == current_user
      body = request.body.read
      @project.values_from_json(JSON.parse(body))
      attempt_save @project
    else
      respond_failure "Not permitted to alter project", :unauthorized
    end
  end

  def create
    project = Project.new
    body = request.body.read
    project.values_from_json(JSON.parse(body))
    project.user = current_user
    attempt_save project
  end

  def destroy
    if @project.user == current_user
      @project.destroy
      respond_success
    else
      respond_failure "Not permitted to delete project", :unauthorized
    end
  end

  def vote
    @project.add_vote(current_user)
    respond_success
  end

  def unvote
    @project.remove_vote(current_user)
    respond_success
  end

private
  def load_project
    id = params[:id]
    @project = Project.find(id)
  rescue ActiveRecord::RecordNotFound
    respond_failure "No project with id #{id} found", :not_found
  end

  def ensure_json_request
    return if request.format == :json
    render nothing: true, status: 406
  end

  def respond_success
    response = {
      success: true,
    }
    render json: response.to_json
  end

  def respond_failure description, status
    response = {
      success: false,
      description: description
    }
    render json: response.to_json, status: status
  end

  def attempt_save project
    if project.save
      respond_success
    else
      respond_failure project.errors.to_json, :unprocessable_entity
    end
  end
end
