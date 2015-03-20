module FormAnswerTestMethods
  def assign_primary(fa, assessor)
    p = fa.assessor_assignments.primary
    p.assessor = assessor
    p.save
  end
end
