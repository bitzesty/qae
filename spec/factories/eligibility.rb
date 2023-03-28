FactoryBot.define do
  factory :eligibility do
    association :account, factory: :account
    association :form_answer, factory: :form_answer

    trait :passed do
      passed { true }
    end

    trait :basic do
      type { "Eligibility::Basic" }
      current_step { :current_holder }
      answers { {
        kind: "application",
        based_in_uk: true,
        do_you_file_company_tax_returns: true,
        organization_kind: "business",
        industry: "product_business",
        self_contained_enterprise: true,
        current_holder: "no",
        adherence_to_esg_principles: true
      }}
    end

    trait :trade do
      type { "Eligibility::Trade" }
      answers { {
        sales_above_100_000_pounds: "yes",
        any_dips_over_the_last_three_years: false,
        current_holder_of_qae_for_trade: false,
        qae_for_trade_award_year: "2015",
        growth_over_the_last_three_years: true
      } }
    end

    trait :innovation do
      type { "Eligibility::Innovation" }
      answers {{
        innovative_product: "yes",
        was_on_market_for_two_years: true,
        number_of_innovative_products: 1,
        had_impact_on_commercial_performace_over_two_years: true,
        have_you_recovered_all_investments: true
      }}
    end

    trait :development do
      type { "Eligibility::Development" }
      answers {{
        sustainable_development: "yes"
      }}
    end

    trait :promotion do
      type { "Eligibility::Promotion" }
      answers {{
        nominee: 'someone_else',
        nominee_contributes_to_promotion_of_business_enterprise: true,
        contribution_is_outside_requirements_of_activity: true,
        nominee_is_active: true,
        nominee_was_active_for_two_years: true,
        contributed_to_enterprise_promotion_within_uk: true,
        nominee_is_qae_ep_award_holder: "no",
        nominee_has_honours: false,
        nominee_was_put_forward_for_honours_this_year: false,
        able_to_get_two_letters_of_support: true
      }}
    end

    factory :basic_eligibility, class: "Eligibility::Basic", traits: [:basic]
    factory :innovation_eligibility, class: "Eligibility::Innovation", traits: [:innovation]
    factory :development_eligibility, class: "Eligibility::Development", traits: [:development]
    factory :trade_eligibility, class: "Eligibility::Trade", traits: [:trade]
    factory :promotion_eligibility, class: "Eligibility::Promotion", traits: [:promotion]
  end
end
