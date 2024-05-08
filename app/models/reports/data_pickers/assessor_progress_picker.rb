class Reports::DataPickers::AssessorProgressPicker

  attr_accessor :award_year_id,
    :award_category

  def initialize(year, award_category)
    self.award_year_id = year.id
    self.award_category = award_category
  end

  def results
    sql_results.map do |entry|
      [
        entry.id,
        entry.name,
        entry.email,
        entry.primary_assigned.to_i,
        entry.primary_assessed.to_i,
        entry.primary_case_summary.to_i,
        entry.primary_feedback.to_i,
        entry.secondary_assigned.to_i,
        entry.secondary_assessed.to_i,
        entry.primary_assigned.to_i + entry.secondary_assigned.to_i,
        entry.primary_assessed.to_i + entry.secondary_assessed.to_i
      ]
    end
  end

  def sql_results
    ActiveRecord::Base.connection.execute(sql_query).entries.map do |entry|
      Hashie::Mash.new(entry)
    end
  end

  def sql_query
    <<-eos
      SELECT DISTINCT(assessors.id) as id,
             concat_ws(' ', assessors.first_name::text, assessors.last_name::text) AS name,
             assessors.email AS email,
             (
               SELECT
               COUNT(*)
               FROM assessor_assignments
               INNER JOIN form_answers
               ON form_answers.id = assessor_assignments.form_answer_id
               WHERE assessor_assignments.assessor_id = assessors.id
                     AND assessor_assignments.position = 0
                     AND assessor_assignments.award_year_id = #{award_year_id}
                     AND form_answers.award_type = '#{award_category}'
             ) As primary_assigned,
             (
               SELECT
               COUNT(*)
               FROM assessor_assignments
               INNER JOIN form_answers
               ON form_answers.id = assessor_assignments.form_answer_id
               WHERE assessor_assignments.assessor_id = assessors.id
                     AND assessor_assignments.position = 0
                     AND assessor_assignments.award_year_id = #{award_year_id}
                     AND assessor_assignments.submitted_at IS NOT NULL
                     AND form_answers.award_type = '#{award_category}'
             ) As primary_assessed,
             (
               SELECT
               COUNT(*)
               FROM assessor_assignments
               INNER JOIN form_answers
               ON form_answers.id = assessor_assignments.form_answer_id
               WHERE assessor_assignments.assessor_id = assessors.id
                     AND assessor_assignments.position = 4
                     AND assessor_assignments.award_year_id = #{award_year_id}
                     AND assessor_assignments.submitted_at IS NOT NULL
                     AND form_answers.award_type = '#{award_category}'
             ) As primary_case_summary,
             (
               SELECT
               COUNT(*)
               FROM feedbacks
               INNER JOIN form_answers
               ON form_answers.id = feedbacks.form_answer_id
               WHERE feedbacks.authorable_id = assessors.id
                     AND feedbacks.authorable_type = 'Assessor'
                     AND feedbacks.award_year_id = #{award_year_id}
                     AND feedbacks.submitted = '1'
                     AND form_answers.award_type = '#{award_category}'
             ) As primary_feedback,
             (
               SELECT
               COUNT(*)
               FROM assessor_assignments
               INNER JOIN form_answers
               ON form_answers.id = assessor_assignments.form_answer_id
               WHERE assessor_assignments.assessor_id = assessors.id
                     AND assessor_assignments.position = 1
                     AND assessor_assignments.award_year_id = #{award_year_id}
                     AND form_answers.award_type = '#{award_category}'
             ) As secondary_assigned,
             (
               SELECT
               COUNT(*)
               FROM assessor_assignments
               INNER JOIN form_answers
               ON form_answers.id = assessor_assignments.form_answer_id
               WHERE assessor_assignments.assessor_id = assessors.id
                     AND assessor_assignments.position = 1
                     AND assessor_assignments.award_year_id = #{award_year_id}
                     AND assessor_assignments.submitted_at IS NOT NULL
                     AND form_answers.award_type = '#{award_category}'
             ) As secondary_assessed
      FROM assessors
      WHERE assessors.confirmed_at IS NOT NULL
            AND assessors.#{award_category}_role IN ('lead', 'regular')
      ORDER BY assessors.id ASC
    eos
  end
end
