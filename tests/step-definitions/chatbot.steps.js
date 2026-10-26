// Steps that talk to the site chatbot the way its chat window does: a session
// first, then the question to the DeepChat API with the session's token.
const assert = require('assert');
const { When, Then } = require('@cucumber/cucumber');

// The AI assistant this recipe sets up for the chatbot.
const ASSISTANT = 'varbase_ai_chatbot';

/**
 * Ask the site chatbot a question, as the current visitor, from the current page.
 *
 * Example #1: When I ask the chatbot "What is Varbase?"
 * Example #2: And I ask the chatbot "How do I add a blog post?"
 * Example #3: When we ask the chatbot "Which modules does the site use?"
 * Example #4: When I ask the chatbot "Who builds this site?"
 * Example #5: And I ask the chatbot "Where can I read the documentation?"
 */
When(/^(?:I |we )*ask the chatbot "([^"]*)"$/, async function (question) {
  this.chatbotReply = await this.page.evaluate(async ({ question, assistant }) => {
    const session = await fetch('/api/deepchat/session', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: '{}' });
    const token = await session.text();
    const reply = await fetch('/api/deepchat?_format=json&token=' + encodeURIComponent(token), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        messages: [{ role: 'user', text: question }],
        chat_processor_plugin: 'ai_assistant_api_processor',
        plugin_configuration: { assistant_id: assistant },
      }),
    });
    return { status: reply.status, text: await reply.text() };
  }, { question, assistant: ASSISTANT });
});

/**
 * Assert the chatbot answered, and that its answer mentions a word.
 *
 * Example #1: Then the chatbot should answer with "Varbase"
 * Example #2: And the chatbot should answer with "Drupal"
 * Example #3: Then the chatbot should answer with "blog"
 * Example #4: Then the chatbot should answer with "Vardot"
 * Example #5: And the chatbot should answer with "documentation"
 */
Then(/^the chatbot should answer with "([^"]*)"$/, function (word) {
  const reply = this.chatbotReply;
  assert.ok(reply, 'The chatbot was not asked anything in this scenario.');
  assert.strictEqual(reply.status, 200, `The chatbot answered with HTTP ${reply.status}: ${reply.text.slice(0, 200)}`);
  let html = '';
  try { html = JSON.parse(reply.text).html || ''; } catch (e) { html = reply.text; }
  const text = html.replace(/<[^>]+>/g, ' ');
  assert.ok(text.includes(word), `The chatbot's answer does not mention "${word}": ${text.slice(0, 300)}`);
});
