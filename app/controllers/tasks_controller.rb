# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  def new 
    @task = Task.new
    @column_id = params[:column_id]
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :column_id)
  end
end