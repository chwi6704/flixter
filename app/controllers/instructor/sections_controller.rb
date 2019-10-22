class Instructor::SectionsController < ApplicationController
before_action :authenticate_user!
before_action :require_authorized_for_current_course, only: [:create]
before_action :require_authorized_for_current_course, only: [:update]


def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.course.update_attributes(section_params)
    render plain: 'updated!'
  end

  private

  def require_authorized_for_current_course
    if current_course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  helper_method :current_section
  def current_section
    if params[:section_id].present?
      @current_section ||= Section.find(params[:section_id])
    else
      current_lesson.section
    end
  end 

  def section_params 
    params.require(:section).permit(:title, :row_order_position)
  end

end
