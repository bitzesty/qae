# -*- coding: utf-8 -*-
class Eligibility::Promotion < Eligibility
  AWARD_NAME = "Enterprise Promotion"

  property :nominee,
            values: %w[yourself someone_else more_than_one_person],
            label: "Who are you nominating?",
            accept: :not_yourself

  property :nominee_contributes_to_promotion_of_business_enterprise,
            boolean: true,
            label: "Does your nominee contribute to the promotion of business enterprise and/or entrepreneurial skills?",
            accept: :true,
            hint: "'Enterprise promotion' covers the encouragement or facilitation of the skills and attitudes found in an enterprise environment. This award is for entrepreneurs, business men and women, innovators and inventors who give their time, knowledge and experience to support other potential entrepreneurs."

  property :contribution_is_outside_requirements_of_activity,
            boolean: true,
            label: "Is this contribution outside the requirements of their paid job/primary activity?",
            accept: :true

  property :nominee_is_active,
            boolean: true,
            label: "Is your nominee still active in the role/area for which you are nominating them?",
            accept: :true

  property :nominee_was_active_for_two_years,
            boolean: true,
            label: "Have they been active in this role/area for at least two years?",
            accept: :true

  property :contributed_to_enterprise_promotion_within_uk,
            boolean: true,
            label: "Has their contribution to enterprise promotion been within the UK (including the Channel Islands and the Isle of Man)?",
            hint: "Foreign nationals are eligible for the award as long as their contribution was within the UK.",
            accept: :true

  property :nominee_is_qae_ep_award_holder,
            values: %w[yes no i_dont_know],
            label: "Does your nominee currently hold a King's Award for Enterprise Promotion?",
            accept: :no_or_i_dont_know

  property :nominee_has_honours,
            boolean: true,
            label: "Does your nominee hold any personal honours?",
            accept: :not_nil,
            hint: "'Personal honours' refers to personal honours awarded by The King, for example, MBE, OBE, Knighthood"

  property :honour_was_ep,
            boolean: true,
            label: "Were they awarded for contribution to enterprise promotion?",
            accept: :false,
            if: proc { nominee_has_honours.nil? || nominee_has_honours? }

  property :nominee_was_put_forward_for_honours_this_year,
            boolean: true,
            label: "Is your nominee being put forward for personal honours this year?",
            accept: :not_nil,
            hint: "'Personal honours' refers to personal honours awarded by The King, for example, MBE, OBE, Knighthood",
            if: proc { nominee_has_honours.nil? || !nominee_has_honours? }

  property :nomination_for_honours_based_on_their_contribution_to_ep,
            boolean: true,
            label: "Is their nomination for personal honours based on their contribution to enterprise promotion?",
            accept: :false,
            if: proc { nominee_was_put_forward_for_honours_this_year.nil? || nominee_was_put_forward_for_honours_this_year? }

  property :able_to_get_two_letters_of_support,
            boolean: true,
            label: "Will you be able to source at least two letters of support for this nomination?",
            accept: :true,
            hint: "Letters of support should be from those (not the nominator) with first-hand knowledge of the nominee's contribution to enterprise promotion, and the impact their work has had on others. One should be from a large organisation, for example, employer, non-profit, local authority."
end
