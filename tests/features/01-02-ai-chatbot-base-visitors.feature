@varbase-ai-chatbot-base @ai @recipes @access @local @development @staging @production
Feature: Varbase AI Recipe - AI Chatbot Base - Visitors may talk to the chatbot
  As a visitor
  I want to use the site chatbot without an account
  So that I can ask about the site and get answers from its pages

  Scenario: Check visitors and signed-in users may use the chatbot API
    Given I am a logged in user with the "Webmaster" user
     When I go to "/admin/people/permissions/module/ai_chatbot"
     Then the Drupal checkbox "edit-anonymous-access-deepchat-api" is checked
      And the Drupal checkbox "edit-authenticated-access-deepchat-api" is checked

  Scenario: Check an anonymous visitor can start a chatbot session
    Given the API base URL is "/"
     When I send a POST request to "api/deepchat/session" with body:
      """
      {}
      """
     Then the API response code should be 200

  Scenario: Check an anonymous visitor cannot change the chatbot
    Given I am an anonymous user
     When I go to "/admin/config/ai/ai-assistant/varbase_ai_chatbot"
     Then the response status code should be 403
      And I should not see "Sorry, I could not answer that just now."
