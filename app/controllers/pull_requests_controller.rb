class PullRequestsController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:project_id])
    @pull_requests = PullRequest.where(project_id: @project.id).order(id: :desc)
  end

  def github_hook
    begin
      if params[:pull_request].present?
        pull_request = PullRequest.find_or_create_by(git_id: params[:pull_request][:id], project_id: Project.find_by(identifier: params[:project_id]).id)
        pull_request.update_attributes(no: params[:pull_request][:number],
                                        git_id: params[:pull_request][:id],
                                        html_url: params[:pull_request][:html_url],
                                        difference_url: params[:pull_request][:html_url]+"/files",
                                        state: params[:pull_request][:state],
                                        title: params[:pull_request][:title])
      end
    rescue Exception => e  
      puts e.message  
      puts e.backtrace.inspect  
    end  
  end
end
