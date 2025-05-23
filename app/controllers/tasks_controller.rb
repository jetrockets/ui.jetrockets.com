class TasksController < ApplicationController
  before_action :set_task, only: [ :destroy, :update, :edit, :toggle_complete ]

  def create
    task = Task.new(task_params)

    if task.save
      redirect_to safari_path, notice: "Task created successfully."
    end
  end

  def update
    if @task.update(task_params)
      redirect_to safari_path, notice: "Task updated successfully."
    end
  end

  def new
    return head :not_found unless turbo_frame_request?

    @task = Task.new
    render partial: "safari/shared/create_task", locals: { task: @task }
  end

  def edit
    return head :not_found unless turbo_frame_request?

    render partial: "safari/shared/update_task", locals: { task: @task }
  end

  def destroy
    @task.destroy
    redirect_to safari_path, notice: "Task deleted successfully."
  end

  def toggle_complete
    @task.update(is_completed: !@task.is_completed)
    redirect_to safari_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :file, :assigned_to, :due_date, types: []).tap do |p|
      p[:types]&.reject!(&:blank?)
      p[:due_date] = Date.strptime(p[:due_date], "%m/%d/%Y") rescue nil if p[:due_date].present?
    end
  end
end
