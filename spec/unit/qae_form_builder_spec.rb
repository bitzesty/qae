require 'rails_helper'

describe QaeFormBuilder do

  it 'should build QaeFormBuilder::Form instances' do
    empty = QaeFormBuilder.build 'test'
    expect(empty.title).to eq('test')
    expect(empty).to be_instance_of(QaeFormBuilder::QaeForm)
  end

  it 'should build 0 steps for empty block' do
    empty = QaeFormBuilder.build 'test'
    expect(empty.steps).to eq([])
  end

  it 'should build form steps' do
    sample = QaeFormBuilder.build 'test' do
      step 'Eligibility', 'El'
      step 'Company Info', 'CI'
      step 'Goods or Services', 'Goods', custom_option: :foo
    end
    expect(sample.steps.size).to eq(3)
    expect(sample.steps[0].title).to eq('Eligibility')
    expect(sample.steps[1].title).to eq('Company Info')
    expect(sample.steps[2].title).to eq('Goods or Services')
    expect(sample.steps[2].opts).to eq(custom_option: :foo)
  end

  it 'should build questions inside steps' do
    sample = QaeFormBuilder.build 'test' do
      step 'Eligibility', 'El' do
        text :org_kind, 'What kind of organisation are you?'
        text :org_uk, 'Is your business based in UK?' do
          context 'Including the Channel Islands and the Isle of Man.'
        end
      end
    end

    expect(sample.steps.size).to eq(1)
    s = sample.steps[0]
    q = s.questions
    expect(q.size).to eq(2)
    expect(q.first.key).to eq(:org_kind)
    expect(q.first.title).to eq('What kind of organisation are you?')
    expect(q.last.key).to eq(:org_uk)
    expect(q.last.title).to eq('Is your business based in UK?')
    expect(q.last.context).to eq('Including the Channel Islands and the Isle of Man.')
  end

  it 'should navigate between steps with decorator' do
    sample = QaeFormBuilder.build 'test' do
      step 'A', 'A'
      step 'B', 'B'
    end

    decorated = sample.decorate
    a = decorated.steps[0]
    b = decorated.steps[1]

    expect(a.index).to eq(0)
    expect(b.index).to eq(1)

    expect(a.previous).to be_nil
    expect(b.next).to be_nil
    expect(b.previous.delegate_obj).to eq(a.delegate_obj)
    expect(a.next.delegate_obj).to eq(b.delegate_obj)
  end

  it 'should report visible? depending on conditionals' do
    sample = QaeFormBuilder.build 'test' do
      step 'test_step', 'test step' do
        options :parent, 'Parent' do
          yes_no
        end

        text :child, 'Child' do
          conditional :parent, 'yes'
        end
      end
    end

    sample_visible = sample.decorate(answers: {parent: 'yes'})
    sample_invisible = sample.decorate(answers: {parent: 'no'})
    expect(sample_visible[:child].visible?).to be_truthy
    expect(sample_invisible[:child].visible?).to be_falsey
  end

  describe "Drop conditions" do
    let(:sample) do
      QaeFormBuilder.build 'test' do
        step 'test_step', 'test step' do
          options :grandparent, 'Grand' do
            option '2 years', '2'
            option '5 years', '5'
          end

          by_years :parent, 'Parent' do
            by_year_condition :grandparent, '2', 2
            by_year_condition :grandparent, '5', 5
            drop_conditional :child
          end

          text :child, 'Child' do
            drop_condition_parent
          end
        end
      end
    end

    let(:sample2visible) do
      sample.decorate(answers: HashWithIndifferentAccess.new({
        grandparent: '2',
        parent_1of2: 2,
        parent_2of2: 1
      }))
    end

    let(:sample2invisible) do
      sample.decorate(answers: HashWithIndifferentAccess.new({
        grandparent: '2',
        parent_1of2: 1,
        parent_2of2: 2
      }))
    end

    let(:sample5visible) do
      sample.decorate(answers: HashWithIndifferentAccess.new({
        grandparent: '5',
        parent_1of5: 1,
        parent_2of5: 2,
        parent_3of5: 3,
        parent_4of5: 0,
        parent_5of5: 5
      }))
    end

    let(:sample5invisible) do
      sample.decorate(answers: HashWithIndifferentAccess.new({
        grandparent: '5',
        parent_1of5: 1,
        parent_2of5: 2,
        parent_3of5: 3,
        parent_4of5: 4,
        parent_5of5: 5
      }))
    end

    it 'should report visible depending on drop conditionals' do
      expect(sample2visible[:child].visible?).to be_truthy
      expect(sample2invisible[:child].visible?).to be_falsey

      expect(sample5visible[:child].visible?).to be_truthy
      expect(sample5invisible[:child].visible?).to be_falsey
    end
  end
end
