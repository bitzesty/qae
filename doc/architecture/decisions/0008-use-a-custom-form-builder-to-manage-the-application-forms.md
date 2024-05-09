# 8. Use a Custom Form Builder to Manage the Application Forms

Date: 2015-03-15

## Status

Accepted

## Context

We have many complex forms that not only need to be accessible but also need to adhere to the government service standard and design system. Additionally, the contents of the forms change year to year.

## Decision

We will create a custom form builder within Ruby on Rails to enable us to easily create forms that meet the standard and also enable us to quickly create or modify new application forms each year.

## Consequences

New forms will be easier to create, and making changes to the forms will be simpler. The DSL for the form builder will need to be learned, but it is a simple one, so new team members should be able to get up to speed quickly.