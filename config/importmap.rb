# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jsqr" # @1.4.0
pin "qrcode", to: "https://ga.jspm.io/npm:qrcode@1.5.4/lib/browser.js"
pin "dijkstrajs" # @1.0.3
pin "@stimulus-components/auto-submit", to: "@stimulus-components--auto-submit.js" # @6.0.0
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "stimulus-use" # @0.52.3
