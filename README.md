[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI Chatbot Base
[![Varbase AI Chatbot Base](https://img.shields.io/badge/Varbase%20AI%20Chatbot%20Base-1.0.0--beta1-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/varbase_ai_chatbot_base)

An **opt-in** Drupal recipe that adds a visitor chatbot to a Varbase 11 site. It answers only from the
site's own content, links the pages it used, and when the site has no answer it says so instead of
guessing. It is the chatbot from the Vardot posts
[How to Build a RAG-Based AI Chatbot on Drupal](https://www.vardot.com/insights/blog/how-build-rag-based-ai-chatbot-drupal)
and [How to Set Up Drupal AI Search with RAG on Varbase](https://www.vardot.com/insights/blog/how-set-drupal-ai-search-rag-varbase),
packaged the Varbase way.

## Documentation

Read the [Varbase AI Chatbot Base documentation](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-chatbot-base) on the Varbase docs site.

## Install and apply

Start from a Varbase 11 site with Varbase AI Base applied, a vector database recipe applied, and Varbase AI Search
applied and indexed. The [Varbase AI Search Base documentation](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-search-base) has those steps,
including its own repository entry, which this recipe needs because it requires Varbase AI Search. Then:

```bash
# 1. Fetch the recipe.
#    The ignore line keeps Varbase AI Search and the vector database recipes on it too.
ddev composer config --json extra.drupal-recipe-unpack.ignore '["drupal/varbase_ai_search_base", "drupal/varbase_ai_chatbot_base", "drupal/varbase_ai_vdb_milvus", "drupal/varbase_ai_vdb_mariadb"]'
ddev composer require drupal/varbase_ai_chatbot_base:~1

# 2. Apply it. The path is relative to the Drupal root.
ddev drush recipe ../recipes/varbase_ai_chatbot_base
ddev drush cr

```

Re-applying is safe: the recipe creates what
is missing and leaves the rest. The ignore line keeps the recipes locked packages: without it core's recipe-unpack
plugin moves a recipe's requirements into the project's `composer.json` and drops the recipe itself.

## Automated testing

GitLab CI on [git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_chatbot_base) (`.gitlab-ci.yml`) builds
a Varbase 11 site, applies this recipe twice and runs the Varbase functional testing suite in `tests/` on it. See
[tests/README.md](tests/README.md) to run it against a site of your own.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).
