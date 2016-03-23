module FormAnswerFilteringTestHelper
  def assert_results_number(n)
    within ".applications-table" do
      expect(page).to have_selector(".td-title", count: n)
    end
  end

  def click_status_option(val)
    within all("th.filter").last do
      first("button").click
      within ".dropdown-menu" do
        all("li").each do |li|
          content = li.first(".label-contents")
          if content
            li.click && return if content.text.to_s == val
          end
        end
      end
    end
    fail "NotFoundOption"
  end

  def assign_dummy_assessors(form_answers, assessor)
    Array(form_answers).each do |fa|
      p = fa.assessor_assignments.primary
      p.assessor_id = assessor.id
      p.save!
    end
  end

  def assign_dummy_audit_certificate(form_answers)
    Array(form_answers).each do |fa|
      audit = fa.build_audit_certificate
      audit.save(validate: false)
    end
  end

  def assign_dummy_feedback(form_answers, submitted = true)
    Array(form_answers).each do |fa|
      feedback = fa.build_feedback(submitted: submitted)
      feedback.save(validate: false)
    end
  end

  def assign_dummy_press_summary(form_answers, approved = true)
    Array(form_answers).each do |fa|
      press_summary = fa.build_press_summary(approved: approved)
      press_summary.save(validate: false)
    end
  end
end
