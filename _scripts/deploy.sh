#!/usr/bin/env bash
bundle install
bundle update --bundler
bundle lock --update
JEKYLL_ENV=development bundle exec jekyll serve
