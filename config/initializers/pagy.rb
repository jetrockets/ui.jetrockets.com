require "pagy/extras/overflow"
require "pagy/extras/array"

Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:limit] = 20
Pagy::DEFAULT[:size] = 4
