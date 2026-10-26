@varbase-ai-chatbot-base @ai @recipes @local @development @staging @production
Feature: Varbase AI Recipe - AI Chatbot Base - A visitor chatbot grounded in the site's content
  As a site owner
  I want a chatbot assistant that searches only this site's vector index before it answers
  So that visitors get answers from our pages, with links, and no guessing

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Check the Varbase AI chatbot assistant uses its own agent
     When I go to "/admin/config/ai/ai-assistant"
     Then I should see "Varbase AI chatbot"
     When I go to "/admin/config/ai/ai-assistant/varbase_ai_chatbot"
     Then I should see "Sorry, I could not answer that just now. Please try again."

  Scenario: Check the chatbot agent can only search the site's vector index
     When I go to "/admin/config/ai/tools-automation/agents/varbase_ai_chatbot/edit/form"
     Then I should see "Varbase AI chatbot"
      And I see visible rag search tool
      And I should see the "content vector index restriction" element in the "agent settings"
      And I should see the "forced index value" element in the "agent settings"

  Scenario: Check the chatbot reuses the vector index of Varbase AI Search Base
     When I go to "/admin/config/search/search-api"
     Then I should see "Content vector (Ask AI)"
