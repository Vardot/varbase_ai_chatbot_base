@varbase-ai @access
Feature: Only site administrators reach what the Varbase AI Chatbot Base recipe adds
  As a site owner
  I want the chatbot assistant kept from visitors who are not administrators
  So that the AI configuration is not exposed

  Scenario: An anonymous visitor cannot open the chatbot assistant
    Given I am an anonymous user
    When I navigate to "/admin/config/ai/ai-assistant"
    Then I should not see "Varbase AI chatbot"
     And I the page should not have PHP errors
