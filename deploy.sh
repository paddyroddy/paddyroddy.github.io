#!/usr/bin/env bash
bundle install
bundle update --bundler
bundle lock --add-platform x86_64-linux
JEKYLL_ENV=development bundle exec jekyll serve
