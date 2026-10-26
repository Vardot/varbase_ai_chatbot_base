# Varbase functional testing suite

Playwright and Cucumber through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e), on a
Varbase 11 site with this recipe applied.

| Feature | Covers |
| --- | --- |
| `01-01-ai-chatbot-base-assistant.feature` | The Varbase AI chatbot assistant, its agent locked to the vector index, and the index it reuses |
| `01-02-ai-chatbot-base-visitors.feature` | Visitors and signed-in users may use the chatbot API and start a session; visitors cannot change it |

The agent tool and its restrictions are named selectors in `tests/selectors/ai-chatbot-base-selectors.json`.

## Run it

```bash
npm install
LAUNCH_URL=https://your-site.ddev.site npm test
```

The site needs the webmaster (`webmaster`) and one user per role, named after the role (`content_editor`,
`content_admin`, `seo_admin`, `site_admin`), all with the password in `LOGIN_PASS` (default `dD.123123ddd`).
`.gitlab-ci.yml` shows the whole setup.

## AI provider

CI applies the recipes this one builds on, in order: the AI module's test provider (EchoAI) as the default with
`tests/recipes/varbase_ai_testing_provider`, Varbase AI VDB: MariaDB, and
Varbase AI Search Base. No key is needed.

The chatbot block cannot be placed on a Canvas theme yet, so there is no chat window to drive here: the suite
checks the assistant, its agent and the visitor permission and session.
