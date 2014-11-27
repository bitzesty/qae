require 'qae_form_builder'

describe QAEFormBuilder do

  it 'should build QAEFormBuilder::Form instances' do
    empty = QAEFormBuilder.build
    expect(empty).to be_instance_of(QAEFormBuilder::Form)
  end

  it 'should build 0 steps for empty block' do
    empty = QAEFormBuilder.build
    expect(empty.steps).to eq([])
  end

  it 'should build form steps' do
    sample = QAEFormBuilder.build do
      step 'Eligibility'
      step 'Company Info'
      step 'Goods or Services', :custom_option => :foo
    end
    expect(sample.steps.size).to eq(3)
    expect(sample.steps[0].title).to eq('Eligibility')
    expect(sample.steps[1].title).to eq('Company Info')
    expect(sample.steps[2].title).to eq('Goods or Services')
    expect(sample.steps[2].options).to eq({:custom_option => :foo})
  end

  it 'should build questions inside steps' do
    sample = QAEFormBuilder.build do
      step 'Eligibility' do
        question :org_kind, 'What kind of organisation are you?'
        question :org_uk, 'Is your business based in UK?',
          :description => 'Including the Channel Islands and the Isle of Man.'
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
    expect(q.last.options[:description]).to eq('Including the Channel Islands and the Isle of Man.')
  end 

end
