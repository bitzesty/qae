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
      answers {
        {
          kind: "application",
          based_in_uk: true,
          do_you_file_company_tax_returns: true,
          organization_kind: "business",
          industry: "product_business",
          self_contained_enterprise: true,
          current_holder: "no",
          adherence_to_esg_principles: true,
        }}
    end

    trait :trade do
      type { "Eligibility::Trade" }
      answers {
        {
          sales_above_100_000_pounds: "yes",
          any_dips_over_the_last_three_years: false,
          has_management_and_two_employees: true,
          current_holder_of_qae_for_trade: false,
          qae_for_trade_award_year: "2015",
          growth_over_the_last_three_years: true,
        } }
    end

    trait :innovation do
      type { "Eligibility::Innovation" }
      answers {
        {
          able_to_provide_financial_figures: "yes",
          has_two_full_time_employees: "yes",
          innovative_product: "yes",
          was_on_market_for_two_years: true,
          number_of_innovative_products: 1,
          had_impact_on_commercial_performace_over_two_years: true,
          have_you_recovered_all_investments: true,
        }}
    end

    trait :development do
      type { "Eligibility::Development" }
      answers {
        {
          able_to_provide_actual_figures: "yes",
          has_management_and_two_employees: "yes",
          sustainable_development: "yes",
          adheres_to_sustainable_principles: "yes",
        }}
    end

    trait :mobility do
      type { "Eligibility::Mobility" }
      answers {
        {
          can_provide_financial_figures: "yes",
          full_time_employees: "yes",
          promoting_opportunity_involvement: "A. We have an initiative that supports social mobility as a discretionary activity (social mobility is not our core activity).",
          promoting_social_mobility: "yes",
          participants_based_in_uk: "yes",
          social_mobility_activities: "yes",
          active_for_atleast_two_years: "yes",
          evidence_of_impact: "yes",
        }}
    end

    trait :promotion do
      type { "Eligibility::Promotion" }
      answers {
        {
          nominee: "someone_else",
          nominee_contributes_to_promotion_of_business_enterprise: true,
          contribution_is_outside_requirements_of_activity: true,
          nominee_is_active: true,
          nominee_was_active_for_two_years: true,
          contributed_to_enterprise_promotion_within_uk: true,
          nominee_is_qae_ep_award_holder: "no",
          nominee_has_honours: false,
          nominee_was_put_forward_for_honours_this_year: false,
          able_to_get_two_letters_of_support: true,
        }}
    end

    factory :basic_eligibility, class: "Eligibility::Basic", traits: [:basic]
    factory :innovation_eligibility, class: "Eligibility::Innovation", traits: [:innovation]
    factory :development_eligibility, class: "Eligibility::Development", traits: [:development]
    factory :trade_eligibility, class: "Eligibility::Trade", traits: [:trade]
    factory :mobility_eligibility, class: "Eligibility::Mobility", traits: [:mobility]
    factory :promotion_eligibility, class: "Eligibility::Promotion", traits: [:promotion]
  end
end
