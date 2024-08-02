# 8. Use a Custom Form Builder to Manage the Application Forms

Date: 2015-03-15

## Status

Accepted

## Context

We have many complex forms that not only need to be accessible but also need to adhere to the government service standard and design system. Additionally, the contents of the forms change year to year.

Previously, we were using simple_form to help create the application forms. However, our forms need to be represented in multiple formats (PDF and HTML) and also have content specific to each format. This led to maintaining two separate copies of each form, one for PDF and one for HTML, which was difficult to keep in sync.

Our application forms also require more complex question types that are not supported by simple_form. For example:

1. Year-specific variations
2. Conditional logic
3. Custom question types with specific word limits
4. Complex form structures with nested sections and custom formatting

## Decision

We will create a custom form builder within Ruby on Rails to enable us to easily create forms that meet the standard and also enable us to quickly create or modify new application forms each year.

This custom form builder will allow us to:
1. Represent forms in multiple formats (PDF and HTML) from a single source.
2. Include format-specific content when necessary.
3. Support complex question types required by our application forms.
4. Implement year-specific variations more efficiently.
5. Handle conditional logic more intuitively.
6. Create custom question types with specific validation rules (e.g., word limits).
7. Manage complex form structures with nested sections and custom formatting.

## Consequences

Positive:
- New forms will be easier to create, and making changes to the forms will be simpler.
- We'll have a single source of truth for each form, reducing maintenance overhead and the risk of inconsistencies between formats.
- The custom form builder will support the complex question types we need for our application forms.
- Year-specific variations can be managed more efficiently
- Conditional logic can be expressed more intuitively.
- Custom question types with specific validation rules can be easily implemented.
- Complex form structures with nested sections and custom formatting can be managed more effectively.

Negative:
- The DSL for the form builder will need to be learned, which might be initially harder to pick up than simple_form for developers already familiar with it.

Neutral:
- While there may be a learning curve for the new DSL, the time taken to learn it will be quickly recouped given that we now have one location for multiple representations of each form.
- The DSL is designed to be simple, so new team members should be able to get up to speed relatively quickly.
