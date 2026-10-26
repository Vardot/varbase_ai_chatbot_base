@varbase-ai-chatbot-base @ai @recipes @a11y @local @development @staging @production
Feature: Varbase AI Recipe - AI Chatbot Base - Accessible chatbot settings
  As a site administrator who uses assistive technology
  I want the chatbot settings page to work with a keyboard and a screen reader
  So that I can manage the chatbot like anyone else

  Scenario: Check the chatbot settings page gives every field a label and every link a name
    Given I am a logged in user with the "Webmaster" user
     When I go to "/admin/config/ai/ai-assistant/varbase_ai_chatbot"
     Then every form field should have an accessible label
      And every link should have an accessible name
      And every ARIA role should be valid
