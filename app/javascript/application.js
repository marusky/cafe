// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "pwa-install-bundle"

if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/service-worker.js')

  console.log('worker ready')
}