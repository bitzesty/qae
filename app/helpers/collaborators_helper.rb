module CollaboratorsHelper
  def came_from_application_form?
    params.has_key? :form_id
  end

  def user_redirected_to_collaborators_page?
    session[:redirected_to_collaborators_page]
  end
end
