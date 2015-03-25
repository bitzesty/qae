class FormAnswerStatusFiltering
  SUB_OPTIONS = {
    missing_audit_certificate: {
      label: "Missing Audit Certificate (not impl.)"
    },
    missing_corp_responsibility: {
      label: "Missing Corp Responsibility (not impl.)"
    },

    missing_feedback: {
      label: "Missing Feedback (not impl.)"
    },

    missing_press_summary: {
      label: "Missing Press Summary (not impl.)",
      properties: {
        checked: "checked"
      }
    }
  }

  OPTIONS = {
    application_in_progress: {
      label: "Application in progress",
      states: [:application_in_progress]
    },
    applications_not_submitted: {
      label: "Applications not submitted",
      states: [:not_submitted]
    },
    submitted: {
      label: "Application submitted",
      states: [:submitted]
    },
    assessment_in_progress: {
      label: "Assessment in progress",
      states: [:assessment_in_progress]
    },
    recommended: {
      label: "Recommended",
      states: [
        :recommended
      ]
    },
    reserve: {
      label: "Reserved",
      states: [
        :reserved
      ]
    },
    not_recommended: {
      label: "Not recomended",
      states: [
        :not_recommended
      ]
    },
    not_eligible: {
      label: "Not eligible",
      states: [
        :not_eligible1
      ]
    },
    withdrawn: {
      label: "Withdrawn",
      states: [
        :withdrawn1
      ]
    }
  }

  def self.collection
    OPTIONS.map do |k, v|
      [v[:label], k]
    end
  end

  def self.sub_collection
    SUB_OPTIONS.map do |k, v|
      [v[:label], k]
    end
  end

  def self.internal_states(filtering_values)
    filtering_values = Array(filtering_values)
    filtering_values.flat_map do |val|
      if supported_filter_attrs.include?(val)
        OPTIONS[val.to_sym][:states]
      end
    end.compact
  end

  def self.supported_filter_attrs
    OPTIONS.keys.map(&:to_s)
  end

  def self.all
    collection.map{|s| s.last.to_s} + sub_collection.map{|s| s.last.to_s}
  end
end
