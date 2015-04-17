FactoryGirl.define do
  factory :eligibility do
    association :account, factory: :account
    association :form_answer, factory: :form_answer

    trait :passed do
      passed true
    end

    trait :basic do
      type "Eligibility::Basic"
      current_step :current_holder
      answers Proc.new {{
        kind: "application",
        based_in_uk: true,
        has_management_and_two_employees: true,
        organization_kind: "business",
        industry: "product_business",
        self_contained_enterprise: true,
        current_holder: "no"
      }}.call
    end

    trait :trade do
      type "Eligibility::Trade"
      answers Proc.new {{
        sales_above_100_000_pounds: "yes",
        any_dips_over_the_last_three_years: true,
        current_holder_of_qae_for_trade: false,
        qae_for_trade_award_year: "2015"
      }}.call
    end

    trait :innovation do
      type "Eligibility::Innovation"
      answers Proc.new {{
        innovative_product: "yes",
        was_on_market_for_two_years: true,
        number_of_innovative_products: 1,
        had_impact_on_commercial_performace_over_two_years: true
      }}.call
    end

    trait :development do
      type "Eligibility::Development"
      answers Proc.new {{
        sustainable_development: "yes"
      }}.call
    end

    factory :basic_eligibility, class: "Eligibility::Basic", traits: [:basic]
    factory :innovation_eligibility, class: "Eligibility::Innovation", traits: [:innovation]
    factory :development_eligibility, class: "Eligibility::Development", traits: [:development]
    factory :trade_eligibility, class: "Eligibility::Trade", traits: [:trade]
  end
end
