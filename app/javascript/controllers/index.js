// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AutoSubmit from '@stimulus-components/auto-submit'

eagerLoadControllersFrom("controllers", application)
application.register('auto-submit', AutoSubmit)
