#!/usr/bin/env bash
bundle install
bundle update --bundler
bundle lock --add-platform x86_64-linux
bundle exec jekyll serve
