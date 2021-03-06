#---
# Excerpted from "Programming Phoenix 1.4",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/phoenix14 for more book information.
#---
# Since configuration is shared in umbrella projects, this file
# should only configure the :rumbl application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :rumbl,
  ecto_repos: [Rumbl.Repo]

import_config "#{Mix.env()}.exs"
