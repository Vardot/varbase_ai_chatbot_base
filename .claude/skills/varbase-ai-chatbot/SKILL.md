---
name: varbase-ai-chatbot
description: "Apply, repair and verify Varbase AI Chatbot on a Varbase 11 site: the visitor chatbot that answers only from the site's content, with links (Varbase AI Chatbot Base). Install and apply commands, inputs, config, post-apply steps, browser checks, traps and versions, read from the recipe code. Use when adding, fixing or checking Varbase AI Chatbot."
---

# Varbase AI Chatbot

Read from `recipe.yml`, `composer.json`, README, CHANGELOG and `git log` at the latest tag, 28 October 2026. Re-check versions on drupal.org before relying on them. For the full Varbase AI apply order, see the Varbase AI recipes docs page.

## Recipes

| Recipe | Latest | Stability | Require |
|---|---|---|---|
| `varbase_ai_chatbot_base` | 1.0.0-beta1 | beta | `drupal/varbase_ai_chatbot_base:~1` |

Docs (the code wins where they differ):
- https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-chatbot-base

## What it does

- Installs `user`, `search_api`, `ai`, `ai_agents`, `ai_assistant_api`, `ai_chatbot`, `ai_search`. Creates agent `varbase_ai_chatbot` (retrieval locked to `content_vector`) and assistant `ai_assistant_api.ai_assistant.varbase_ai_chatbot`, and grants the chatbot permission to anonymous and authenticated. Applies no sub-recipe: it reuses the index of Search Base.
- Composer: `ai ^1.5`, `ai_agents ^1.3`, `ai_search ^1.3@alpha`, `search_api ^1.40`, `varbase_ai_search_base ^1.0`. No inputs.

## Apply

All commands in DDEV, from the project root; recipes are applied from the docroot path `../recipes/<name>`. Take a snapshot first: `ddev snapshot --name before-varbase-ai-chatbot`. Add each recipe to `extra.drupal-recipe-unpack.ignore` in `composer.json` before requiring it (read the list first: `composer config --json` replaces it).

```bash
ddev composer require drupal/varbase_ai_chatbot_base:~1
ddev drush cr
ddev drush recipe ../recipes/varbase_ai_chatbot_base -y   # after Search Base is applied and indexed
ddev drush cr
```

## After the apply

- Place the "AI DeepChat Chatbot" block in Block layout, in a region that prints on every page: assistant "Varbase AI chatbot", streaming off, bottom right. Canvas pages print no block regions, so the block cannot sit inside a Canvas page (its schema is not FullyValidatable).
- Attach the guardrail sets to the assistant (see `varbase-ai-safety`), then check a prompt injection is refused.

## Verify

- `ddev drush cget ai_assistant_api.ai_assistant.varbase_ai_chatbot`.
- In a browser as an anonymous visitor: accept the Klaro consent, open the launcher, ask about something on the site: the answer links to the pages it used; ask about something absent: it says the site has no answer.

Test as a real editor or visitor, not user 1: a superuser bypasses permissions.

## Traps

- Klaro hides the launcher until the visitor consents.
- Re-applying is safe (README). Restore the search view modes after it if they changed.

## History

Started 22 Oct 2026, 1.0.0-alpha1 24 Oct, 1.0.0-beta1 27 Oct (functional tests #3633132).
