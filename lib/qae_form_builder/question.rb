class QAEFormBuilder

  class QuestionDecorator < QAEDecorator
    def input_name options = {}
      if options[:index]
        suffix = options.fetch(:suffix)
        "#{form_name}[#{delegate_obj.key}][#{options[:index]}][#{suffix}]"
      else
        "#{form_name}[#{hash_key(options)}]"
      end
    end

    def input_value options = {}
      result = if options[:index]
        suffix = options.fetch(:suffix)
      ## TODO: maybe we switch to JSON from hstore?
        json = JSON.parse(answers[delegate_obj.key] || {})
        json[options[:index]][suffix]
      else
        answers[hash_key(options)]
      end

      if options[:json]
        JSON.parse(result || '{}')
      else
        result
      end
    end

    def required_sub_fields
      []
    end

    def array_answer
      false
    end

    def answers
      @decorator_options.fetch(:answers)
    end

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def hash_key options = {}
      options[:suffix] ? "#{delegate_obj.key}_#{options[:suffix]}" : delegate_obj.key
    end

    def fieldset_classes
      result = ["question-block",
       "js-conditional-answer"]
      result << delegate_obj.classes if delegate_obj.classes
      result << "question-required" if delegate_obj.required
      result << "js-conditional-drop-answer" if delegate_obj.drop_condition
      result << "js-conditional-drop-block-answer" if delegate_obj.drop_block_condition
      result
    end

    def fieldset_data_hash
      result = {answer: delegate_obj.parameterized_title}
      result['drop-question'] = delegate_obj.form[delegate_obj.drop_condition].parameterized_title if delegate_obj.drop_condition
      result
    end

    def has_drops?
      if delegate_obj.drop_condition_parent.present?
        step.questions.select do |q|
          q.drop_condition.present? &&
          q.drop_condition == key
        end.any? do |q|
          q.has_drops?
        end
      end
    end

    def required?
      delegate_obj.required
    end

    def visible?
      dc = delegate_obj.drop_condition_parent
      delegate_obj.conditions.
        all?{|condition|
          question_value = condition.question_value
          parent_question_answer = step.form[condition.question_key].input_value

          if question_value == :true
            parent_question_answer.present?
          else
            parent_question_answer == question_value.to_s
          end
        } &&
      (!dc || (dc.present? && has_drops?))
    end

    def required_visible?
      required? && visible?
    end

    def required_visible_filled?
      return false unless required_visible?
      required_sub_fields.blank? ? !input_value.blank? :
        required_sub_fields.all?{|s| !input_value(suffix: s.keys.first).blank?}
    end

    def escaped_title
      if delegate_obj.title.present?
        title = delegate_obj.title

        title = Nokogiri::HTML.parse(title).text
        title.strip
      end
    end

    def escaped_context
      if delegate_obj.context.present?
        context = delegate_obj.context

        context = Nokogiri::HTML.parse(context).text
        context.strip
      end
    end
  end

  class QuestionBuilder
    def initialize q
      @q = q
    end

    def context text
      @q.context = text
    end

    def classes text
      @q.classes = text
    end

    def ref id
      @q.ref = id
    end

    def required
      @q.required = true
    end

    def help title, text
      @q.help << QuestionHelp.new(title, text)
    end

    def hint title, text
      @q.hint << QuestionHelp.new(title, text)
    end

    def form_hint text
      @q.form_hint = text
    end

    def conditional key, value
      @q.conditions << QuestionCondition.new(key, value)
    end

    def drop_conditional key
      @q.drop_condition = key.to_s.to_sym
    end

    def drop_block_conditional
      @q.drop_block_condition = true
    end

    def drop_condition_parent
      @q.drop_condition_parent = true
    end

    def header header
      @q.header = header
    end

    def header_context header_context
      @q.header_context = header_context
    end
  end

  QuestionCondition = Struct.new(:question_key, :question_value)

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :step,
                  :key,
                  :title,
                  :context,
                  :opts,
                  :required,
                  :help,
                  :hint,
                  :form_hint,
                  :ref,
                  :conditions,
                  :header,
                  :header_context,
                  :classes,
                  :drop_condition,
                  :drop_condition_parent,
                  :drop_block_condition

    def initialize step, key, title, opts={}
      @step = step
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
      @hint = []
      @conditions = []
      self.after_create if self.respond_to?(:after_create)
    end

    def decorate options = {}
      kls_name = self.class.name.split('::').last
      kls = QAEFormBuilder.const_get "#{kls_name}Decorator" rescue nil
      (kls || QuestionDecorator).new self, options
    end


    def form
      step.form
    end

    def parameterized_title
      key.to_s + "-" + title.parameterize
    end

  end

end

