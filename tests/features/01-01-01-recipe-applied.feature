@varbase-ai @chatbot @recipe
Feature: The Varbase AI Chatbot Base recipe sets up a grounded visitor chatbot
  As a Varbase site builder
  I want the recipe to add the chatbot agent and its AI Assistant
  So that the DeepChat block can answer visitors from the site's own content

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: The chatbot agent exists
    When I navigate to "/admin/config/ai/tools-automation/agents"
    Then I should see "Varbase AI chatbot"
     And I the page should not have PHP errors

  Scenario: The chatbot AI Assistant exists
    When I navigate to "/admin/config/ai/ai-assistant"
    Then I should see "Varbase AI chatbot"
     And I the page should not have PHP errors

  Scenario: The vector index from Varbase AI Search Base is there
    When I navigate to "/admin/config/search/search-api"
    Then I should see "Content vector (Ask AI)"
     And I the page should not have PHP errors
