class Eligibility::Innovation < Eligibility
  AWARD_NAME = "Innovation"

  validates :number_of_innovative_products, presence: true, numericality: { only_integer: true, greater_than_0: true, allow_nil: true }, if: proc {
                                                                                                                                               innovative_product? && (!current_step || current_step == :number_of_innovative_products)
                                                                                                                                             }

  property :able_to_provide_financial_figures,
           boolean: true,
           label: "Will you be able to provide financial figures for at least your two most recent financial years, covering the full 24 months?",
           hint: "For the purpose of this application, your most recent financial year-end is your last financial year-end before the #{Settings.current_submission_deadline.decorate.formatted_trigger_date("with_year")} - the application submission deadline. If you haven't reached your most recent year-end, you can provide estimated figures in the interim.<br><br>If your financial year end has changed within your last two financial years, and one of the periods is shorter than 12 months, you will have to provide figures for at least one additional year.",
           accept: :true

  property :has_two_full_time_employees,
           boolean: true,
           label: "Did your organisation have at least two full-time UK employees or full-time equivalent employees (FTEs) in your two most recent financial years?",
           hint: %(
              <p class='govuk-hint'>You can calculate the number of full-time employees at the year-end, or the average for each 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>
              <p class='govuk-hint'>If your organisation is based in the Channel Islands or Isle of Man, you should count only the employees who are located there (do not count employees who are in the UK).</p>
            ),
           accept: :true

  property :innovative_product,
           values: %w[yes no skip],
           acts_like_boolean: true,
           label: "Do you have an innovative product, service, business model or process?",
           accept: :true,
           hint: "A product, service, business model or process is innovative if it has not been done before and provides a benefit or solves prior problems for its users."

  property :number_of_innovative_products,
           positive_integer: true,
           label: "How many innovative products, services, business models or processes would you like to enter for the award?",
           accept: :not_nil,
           hint: "You can apply for multiple awards if you have more than one innovation. Each one requires a separate application to be submitted. If so, we recommend that you continue with this application with one innovation in mind and then start new applications for each one of the others.",
           if: proc { !skipped? && (innovative_product.nil? || innovative_product?) }

  property :was_on_market_for_two_years,
           boolean: true,
           label: "Has the innovation been on the market for at least two years?",
           accept: :true,
           hint: "If you have more than one innovation, please decide which one you will be applying for first and answer this and subsequent questions with that innovation in mind.",
           if: proc { !skipped? }

  property :had_impact_on_commercial_performace_over_two_years,
           boolean: true,
           label: "Has the innovation had a positive impact on your commercial success (in terms of turnover or profitability) over at least the last two years?",
           accept: :true,
           if: proc { !skipped? }

  property :have_you_recovered_all_investments,
           boolean: true,
           label: "Have you recovered all the investments made in your innovation, or can you demonstrate that the innovation will recover its full costs in the future?",
           accept: :true,
           if: proc { !skipped? }
end
