@varbase-ai-chatbot-base @ai @recipes @access @local @development @staging @production
Feature: Varbase AI Recipe - AI Chatbot Base - Visitors talk to the chatbot, only administrators change it
  As a site owner
  I want visitors to use the chatbot without being able to change it
  So that the chatbot keeps answering the way the site set it up

  Scenario: Check an anonymous visitor cannot change the chatbot
    Given I am an anonymous user
     When I go to "/admin/config/ai/ai-assistant/varbase_ai_chatbot"
     Then the response status code should be 403
      And I should not see "Sorry, I could not answer that just now."

  Scenario: Check the webmaster can open the chatbot settings
    Given I am a logged in user with the "Webmaster" user
     When I go to "/admin/config/ai/ai-assistant/varbase_ai_chatbot"
     Then I should see "Sorry, I could not answer that just now. Please try again."
