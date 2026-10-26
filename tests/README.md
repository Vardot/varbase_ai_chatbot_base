# Varbase functional testing suite

Playwright and Cucumber through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e), on a
Varbase 11 site with this recipe applied.

| Feature | Covers |
| --- | --- |
| `01-01-ai-chatbot-base-conversation.feature` | A visitor asks the chatbot about the site and gets an answer from its pages |
| `01-02-ai-chatbot-base-visitors.feature` | Visitors cannot change the chatbot; the webmaster opens its settings |
| `01-03-ai-chatbot-base-accessibility.feature` | The chatbot settings page gives every field a label and every link a name |

## Run it

```bash
npm install
LAUNCH_URL=https://your-site.ddev.site npm test
```

The site needs the webmaster (`webmaster`) and one user per role, named after the role (`content_editor`,
`content_admin`, `seo_admin`, `site_admin`), all with the password in `LOGIN_PASS` (default `dD.123123ddd`).
`.gitlab-ci.yml` shows the whole setup.

## AI provider

CI applies the recipes this one builds on, in order: Drupal CMS AI, which sets up an amazee.ai trial as the
default provider, Varbase AI VDB: MariaDB and Varbase AI Search Base, which embeds the site's content. No key
is needed and the chatbot answers from a real model, in about 7 seconds on a local site.

The recipe does not place the chatbot block, so the suite asks its question the way the chat window does: the
steps in `tests/step-definitions/chatbot.steps.js` start a session and send the question to the DeepChat API
from the visitor's browser.
