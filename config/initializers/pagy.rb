require "pagy/extras/overflow"

Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:limit] = 20
Pagy::DEFAULT[:size] = 4
