@varbase-ai-chatbot-base @ai @recipes @local @development
Feature: Varbase AI Recipe - AI Chatbot Base - A visitor chatbot grounded in the site's content
  As a site visitor
  I want to ask the site's chatbot a question in my own words
  So that I get an answer from the site's own pages instead of searching for it

  Scenario: Verify a visitor asks the chatbot about the site and gets an answer from its pages
    Given I am an anonymous user
      And I am on the homepage
     When I ask the chatbot "What is Varbase?"
     Then the chatbot should answer with "Varbase"
