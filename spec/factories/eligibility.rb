FactoryGirl.define do
  factory :eligibility do
    association :user, factory: :user
    association :form_answer, factory: :form_answer
  
    trait :passed do
      passed true
    end

    trait :basic do
      type 'Eligibility::Basic'
      answers Proc.new {{
        kind: "application",
        based_in_uk: true,
        has_management_and_two_employees: true,
        organization_kind: "business",
        industry: "product_business",
        registered: true,
        self_contained_enterprise: true,
        demonstrated_comercial_success: true,
        current_holder: false
      }}.call      
    end

    trait :trade do
      type 'Eligibility::Trade'
      answers Proc.new {{
        sales_above_100_000_pounds: true,
        any_dips_over_the_last_three_years: true,
        current_holder_of_qae_for_trade: false,
        qae_for_trade_expiery_date: '2019'
      }}.call
    end

    trait :innovation do
      type 'Eligibility::Innovation'
      answers Proc.new {{
        innovative_product: true, 
        was_on_market_for_two_years: true, 
        number_of_innovative_products: 1, 
        innovation_recouped_investments: true, 
        had_impact_on_commercial_performace_over_two_years: true
      }}.call
    end

    trait :development do
      type 'Eligibility::Development'
      answers Proc.new {{
        sustainable_development: true,
        development_contributed_to_commercial_success: true
      }}.call
    end

    factory :basic_eligibility, class: "Eligibility::Basic", traits: [:basic, :passed]
    factory :innovation_eligibility, class: "Eligibility::Innovation", traits: [:innovation, :passed]
    factory :development_eligibility, class: "Eligibility::Development", traits: [:development, :passed]
    factory :trade_eligibility, class: "Eligibility::Trade", traits: [:trade, :passed]
  end
end