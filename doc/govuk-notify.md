# GOV.UK Notify

Emails sent from our website (across dev, staging, and production) utilise [Gov Notify](https://www.notifications.service.gov.uk/). This includes account confirmations, password resets, and various system mailers. All system emails use the `'Universal Email Template'`, which must not be edited to prevent email sending failures or incorrect information dissemination.

Occasionally, system mailers may fail to send due to non-existent email addresses or delivery issues. In such cases, or when a system email needs to be resent, this can be manually done via Notify by creating a custom template. The steps are as follows:

- Log into Notify > Templates > New template > Email
- Enter the template name, subject line, and email body
- Follow the formatting instructions to match the original email style
- Use the double bracket ((PERSONALISED INPUT)) in the subject line or body for personalisation. This could be a name, company name, or unique link (you may need to ask a developer to regenerate it or use it from a previously sent email). Save and preview the email for testing.
- Once ready, click 'Get ready to send'. You can send emails individually or in bulk by uploading a CSV file with all the personalised inputs in each column.