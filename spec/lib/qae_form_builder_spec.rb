require 'rails_helper'

describe QaeFormBuilder do
  subject do
    described_class.build 'Dummy Award' do
      step 'Step1', 'step1', &DummyForm.step1
    end
  end

  let(:current_step){ subject.steps.first }

  describe '#build' do
    it 'creates the questions' do
      expect(current_step.questions.size).to eq(3)
    end

    it 'assigns the correct types for specific questions' do
      [/Option/, /Number/, /Date/].each_with_index do |type_reg, index|
        expect(current_step.questions[index].class.to_s =~ type_reg).to be_present
      end
    end

    it 'adds help context' do
      help = current_step.questions[1].help
      expect(help.first.title =~ /That is the/).to be_present
    end

    it 'assigns required flag' do
      expect(current_step.questions[1].decorate).to be_required
    end

    it 'assigns date_max flag' do
      expect(current_step.questions[2].date_max).to eq '01/10/2015'
    end
  end
end

class DummyForm
  def self.step1
    @step1 = Proc.new {
      options :option_question1, 'Are you keen to choose any option?' do
        ref 'X 1'
        option 'option1', 'option1 value'
        option 'option2', 'option2 value'
      end

      number :number_question1, 'How old are you?' do
        ref 'X 2'
        required
        help 'That is the time you spent on the planet (in seconds).', '<p>sth</p>'
      end

      date :date_question1, 'When is the end of year?' do
        ref 'X 3'
        required
        date_max '01/10/2015'
      end
    }
  end
end
