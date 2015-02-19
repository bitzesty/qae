class FormAnswerStatusFiltering
  SUB_OPTIONS = {
    missing_audit_certificate: {
      label: 'Missing Audit Certificate (not impl.)',
      properties: {
        checked: 'checked'
      }
    },
    missing_corp_responsibility: {
      label: 'Missing Corp Responsibility (not impl.)',
      properties: {
        checked: 'checked'
      }
    },

    missing_feedback: {
      label: 'Missing Feedback (not impl.)',
      properties: {
        checked: 'checked'
      }
    },

    missing_press_summary: {
      label: 'Missing Press Summary (not impl.)',
      properties: {
        checked: 'checked'
      }
    }
  }

  OPTIONS = {
    application_in_progress: {
      label: 'Application in progress',
      states: [:in_progress1]
    },
    assessment_in_progress: {
      label: 'Assessment in progress (not impl.)',
      states: [:assessment_in_progress2]
    },
    recommended: {
      label: 'Recommended (not impl.)',
      states: [
        :recommended3,
        :recommended4,
        :recommended5
      ]
    },
    reserve: {
      label: 'Reserve (not impl.)',
      states: [
        :reserved3,
        :reserved4,
        :reserved5
      ]
    },
    not_recommended: {
      label: 'Not recomended (not impl.)',
      states: [
        :not_recommended3,
        :not_recommended4,
        :not_recommended5
      ]
    },
    not_eligible: {
      label: 'Not Eligible (not impl.)',
      states: [
        :not_eligible1,
        :not_eligible2,
        :not_eligible6
      ]
    },
    withdrawn: {
      label: 'Withdrawn (not impl.)',
      states: [
        :withdrawn1,
        :withdrawn2,
        :withdrawn3,
        :withdrawn4,
        :withdrawn5
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
    filtering_values.map do |val|
      if supported_filter_attrs.include?(val)
        OPTIONS[val.to_sym][:states]
      end
    end.compact
  end

  def self.supported_filter_attrs
    OPTIONS.keys.map(&:to_s)
  end
end