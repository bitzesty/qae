module AssessorsHelper
  def available_assessors_for_select
    Assessor.available_for(resource.award_type_slug).map do |a|
      [a.full_name, a.id]
    end
  end
end
