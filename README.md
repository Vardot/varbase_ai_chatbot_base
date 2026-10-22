[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI Chatbot Base
[![CI](https://github.com/Vardot/varbase_ai_chatbot_base/actions/workflows/ci.yml/badge.svg?branch=1.0.x)](https://github.com/Vardot/varbase_ai_chatbot_base/actions/workflows/ci.yml)
[![Varbase AI Chatbot Base](https://img.shields.io/badge/Varbase%20AI%20Chatbot%20Base-1.0.2-0d6efc?labelColor=001d38&style=flat-square)](https://github.com/Vardot/varbase_ai_chatbot_base/releases/tag/1.0.2)

A private, **opt-in** Drupal recipe that adds a visitor chatbot to a Varbase 11 site. It answers only from the
site's own content, links the pages it used, and when the site has no answer it says so instead of
guessing. It is the chatbot from the Vardot posts
[How to Build a RAG-Based AI Chatbot on Drupal](https://www.vardot.com/insights/blog/how-build-rag-based-ai-chatbot-drupal)
and [How to Set Up Drupal AI Search with RAG on Varbase](https://www.vardot.com/insights/blog/how-set-drupal-ai-search-rag-varbase),
packaged the Varbase way.

**Experimental.** `ai_search` declares `lifecycle: experimental`, so this stack is not covered by the Drupal
security advisory policy. Of the three vector database providers, only MariaDB has a stable release.

There is **no custom PHP and no custom shell code** in the recipe. Its no-key checks run inline in CI, so the repository holds no PHP file at
all.

## What it adds

| Part | What it does |
|---|---|
| Agent `varbase_ai_chatbot` | Searches the site's vector index before every answer, answers only from what it found, links each page it used as a markdown link, and replies "I could not find matching information on this site for that question." when nothing matches. Its search tool is locked to the `content_vector` index. |
| AI Assistant `varbase_ai_chatbot` | What the DeepChat chatbot block talks to. Runs the agent with the site's default chat model at temperature 0.2, keeps the last 5 messages of a conversation, and is open to anonymous and authenticated visitors. |
| Permission | `access deepchat api` for anonymous and authenticated users, which the chatbot's API needs. |

It reuses the vector index built by [Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base) rather than
embedding the content a second time, so apply that recipe first. Varbase AI Search holds only the vector index.
Ask AI, a separate feature over the same index, is [Varbase AI Answers](https://github.com/Vardot/varbase_ai_answers_base).
This recipe does not depend on it.

## Requirements

- Drupal core `^11.4`, Varbase 11
- [`drupal/ai`](https://www.drupal.org/project/ai) `^1.5`, which ships the AI Assistant API and AI Chatbot modules
  the recipe installs
- [`drupal/ai_agents`](https://www.drupal.org/project/ai_agents) `^1.3`
- [`drupal/ai_search`](https://www.drupal.org/project/ai_search) `^1.3@alpha`
- [`drupal/search_api`](https://www.drupal.org/project/search_api) `^1.40`
- [`vardot/varbase_ai_search_base`](https://github.com/Vardot/varbase_ai_search_base) `^1.0` (private), applied and indexed
  first
- A default chat model and a default embeddings model (Varbase AI Base sets them, under Configuration > AI > AI
  settings), and a vector database recipe applied

## Install and apply

Start from a Varbase 11 site with Varbase AI Base applied, a vector database recipe applied, and Varbase AI Search
applied and indexed. The [Varbase AI Search README](https://github.com/Vardot/varbase_ai_search_base) has those steps,
including its own repository entry, which this recipe needs because it requires Varbase AI Search. Then:

```bash
# 1. Fetch the recipe. The repository is private, so Composer clones it over SSH.
#    The ignore line keeps Varbase AI Search and the vector database recipes on it too.
ddev auth ssh
ddev composer config repositories.varbase_ai_chatbot_base vcs git@github.com:Vardot/varbase_ai_chatbot_base.git
ddev composer config --json extra.drupal-recipe-unpack.ignore '["vardot/varbase_ai_search_base", "vardot/varbase_ai_chatbot_base", "vardot/varbase_ai_vdb_milvus", "vardot/varbase_ai_vdb_mariadb", "vardot/varbase_ai_vdb_sqlite"]'
ddev composer require vardot/varbase_ai_chatbot_base:~1.0.2 --prefer-source

# 2. Apply it. The path is relative to the Drupal root.
ddev drush recipe ../recipes/varbase_ai_chatbot_base
ddev drush cr

# 3. Check it. Without questions it needs no AI key. Each question costs one model call.
ddev drush php:eval "$(sed -n "/<<'PHP'/,/^ *PHP\$/p" recipes/varbase_ai_chatbot_base/.github/workflows/ci.yml | sed '1d;$d')"
ddev drush php:eval "$(sed -n "/<<'PHP'/,/^ *PHP\$/p" recipes/varbase_ai_chatbot_base/.github/workflows/ci.yml | sed '1d;$d' \
  | sed "s/^ *\$extra = .*/\$extra = ['Can I run my website in more than one language?', 'What will the weather be like tomorrow?'];/")"
```

Use `1.0.x-dev` instead of `~1.0.2` to follow the development branch. Re-applying is safe: the recipe creates what
is missing and leaves the rest. The ignore line keeps the recipes locked packages: without it core's recipe-unpack
plugin moves a recipe's requirements into the project's `composer.json` and drops the recipe itself.

## Showing the chatbot on pages

The chatbot is the **AI DeepChat Chatbot** block from the AI module, with its assistant set to
**Varbase AI chatbot**. Recommended block settings: placement *Bottom right*, streaming **off** (with streaming
on, the retrieved context was intermittently dropped mid-answer), and a first message that says the
chatbot answers only from the site's own pages.

**On a Canvas theme (Varbase 11) this recipe cannot place the block, and neither can a site builder yet.**
Canvas renders the whole page, header and footer included, so ordinary block regions do not print, and Canvas
refuses the DeepChat block as a component:

> Block plugin settings must opt into strict validation. Use the FullyValidatable constraint.

That is a gap in the AI module's `ai_chatbot` block schema, to be fixed upstream on drupal.org and carried by
`vardot/varbase-patches` until it is released. Once Canvas accepts the block, a site builder adds it to the
global footer once in the Canvas editor, with no code. Canvas has no config action that adds a single component
to a page region without replacing the region's whole tree, so a shared recipe should not do that step.

On a theme that renders block regions, place the block in any region from Block layout as usual.

## Consent

Varbase's Klaro consent manager gates DeepChat. A visitor sees "Load service chatbot Deepchat (uses session
cookie and sends data to external service)?" and the chatbot loads only after they accept. That is intended:
the visitor's question and the retrieved passages are sent to the AI provider. Klaro is not changed by this
recipe.

## Where data goes

- The content stays in Drupal and in the vector database, on infrastructure the site owner chooses.
- Indexing sends each content chunk to the embeddings provider once (and again when the content changes).
- Each answer sends the visitor's question and the retrieved passages to the chat model provider. Choose a
  provider whose data terms fit the site, or a self-hosted model through the Drupal AI provider system.

## Automated testing

`.github/workflows/ci.yml` runs on every pull request, every push to `1.0.x` and every tag:

1. **Lint**: `composer validate`, every YAML file, and PHP syntax.
2. **Apply on a Varbase 11 site after Varbase AI Search**: the same site as Varbase AI Search's CI, a real Varbase 11 site, built the way Vardot's public recipe CI builds one: `drupal/varbase_project` `11.0.x-dev` with Varbase's curated patches, installed from Varbase Starter, on MariaDB 11.8, which is also the vector database. Twig is held below 3.30, which breaks the `cva` module Varbase uses.
   - It requires this checkout, Varbase AI Search and the MariaDB provider.
   - Varbase Search Base is applied first, before the MariaDB provider (see the known issues).
   - Then the provider and the defaults: the AI module's Echo test provider (`echoai`, model `gpt-test`) is the
     default embeddings model, so no AI key is needed, MariaDB is the default vector database, and the
     `varbase_ai_search` database is created.
   - Then Varbase AI Search, then this recipe twice. It must be safe to re-apply.
   - The no-key recipe check runs last.
3. **Functional tests**: the same job then serves the site and runs the Playwright + Cucumber scenarios in
   `tests/features` through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e) in
   Chromium. The Webmaster provisions the testing users first, then the scenarios check the admin pages the
   recipe adds, every page for PHP errors, and that a visitor without the permission is kept out. Screenshots
   and reports of a failed run are kept as the `functional-tests` artifact. To run them against a site of
   your own: `yarn install`, then `LAUNCH_URL=https://your-site.ddev.site yarn test`.

Varbase AI Search is a private repository, so CI reads it with a read-only deploy key: the secret
`VARBASE_AI_SEARCH_DEPLOY_KEY` in this repository holds the private half, and the public half is a deploy key on
`Vardot/varbase_ai_search_base` only.

The CI step "Check the recipe without an AI key" (an inline `drush php:eval` in `.github/workflows/ci.yml`) needs no AI key. It checks the modules, the `content_vector` index the agent
is locked to, the agent and its lock, the assistant (it runs the agent and allows anonymous visitors), and the
visitor permission. It reports how many items the index holds as an INFO line, not a check: indexing is Varbase AI
Search's job, and in CI the index is empty by design. Any failed check fails the command. Given questions, it also
asks each one through the assistant, which costs one model call per question and needs the AI keys.

## Checked

In CI on every change, as above. By hand on 8 October 2026, on a Varbase 11 site (profile 11.0.0-rc1, Drupal
11.4.5, Canvas 1.12.0, AI 1.5.0, and the standalone AI Search module `drupal/ai_search` 1.3.0-alpha5; the copy
bundled in AI 1.5.0 is deprecated), with Milvus 2.6 in DDEV through `varbase_ai_vdb_milvus`, OpenAI
`text-embedding-3-small` for embeddings and Anthropic `claude-opus-5` as the default chat model, after Varbase AI
Search indexed 63 items:

- The recipe applied, and applied again, without errors.
- The recipe check passed all 14 structural checks of that version. One of them checked that the index held
  content. That line is now INFO, so the test makes 13 checks.
- "Can I run my website in more than one language?" was answered from the site's multilingual blog post, with
  links to it and to its French translation. Over the runs it took between 6 and 16 seconds.
- "What will the weather be like tomorrow?" was answered with the refusal line, in 5 to 8 seconds.

**Not checked:** applying it before Varbase AI Search (it should stop on the missing `content_vector` index),
answering on other vector databases than Milvus (CI applies it on MariaDB but asks nothing), and other chat models.

## Known issues

- On a Canvas theme the chatbot block cannot be placed yet (see
  [Showing the chatbot on pages](#showing-the-chatbot-on-pages)).
- With streaming on, the retrieved context was intermittently dropped mid-answer. Keep streaming off on the block.
- **`ai_vdb_provider_mariadb` 1.0.1**, which CI uses, crashes with `Call to a member function getBackend() on null`
  when a Search API index with no server yet is saved, which the Drupal CMS Search recipe inside Varbase Search
  Base does. Apply Varbase Search Base before installing the provider. A Varbase site already has it applied, and
  CI does the same. See the [MariaDB recipe README](https://github.com/Vardot/varbase_ai_vdb_mariadb).

## Related recipes

| Recipe | What it does |
|---|---|
| [Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base) | The vector index of the site's content, on the default vector database. |
| [Varbase AI Answers](https://github.com/Vardot/varbase_ai_answers_base) | Ask AI: cited answers over that index. |
| [Varbase AI VDB: MariaDB](https://github.com/Vardot/varbase_ai_vdb_mariadb) | MariaDB's native `VECTOR` type as the vector database. |
| [Varbase AI VDB: Milvus](https://github.com/Vardot/varbase_ai_vdb_milvus) | Milvus or Zilliz Cloud as the vector database. |
| [Varbase AI VDB: SQLite](https://github.com/Vardot/varbase_ai_vdb_sqlite) | SQLite with sqlite-vec as the vector database. |

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).
