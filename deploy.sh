#!/usr/bin/env bash
JEKYLL_ENV=development
bundle install
bundle update --bundler
bundle lock --add-platform x86_64-linux
bundle exec jekyll serve
