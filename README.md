# rism-website-indexer

This plugin generates a `/pages.json` file for indexing the content of the website. It is meant to be used with the [rism-theme](https://github.com/rism-digital/rism-theme) Jekyll theme that includes various scripts and templates that work with it.

To activate the plugin, you need to add to the website `Gemfile`

```ruby
group :jekyll_plugins do
  gem "rism-website-indexer", git: 'https://github.com/rism-digital/rism-website-indexer', branch: :main
end
```

Building the website with Jekyll will make the plugin generate a `_site/pages.json` file. Once this is done, and search index file can be built from it. This can be done with `node` by running the `build_index.js` script available in the `rism-theme`.

The script uses two `npm` packages:
* lunr
* lunr-languages

You need to make sure that you use the same version of `lunr` than the one included in the `rism-theme` assets (currently 2.3.9).

From the root of the website, you need to run:
```shell
npm install lunr@2.3.9
npm install lunr-languages
node _site/assets/js/build_index.js _site/pages.json _site/index.json 
```
