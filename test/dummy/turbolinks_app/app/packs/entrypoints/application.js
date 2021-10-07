import Turbolinks from "turbolinks"
import { startUjs, startTurbolinks } from "@yuki24/shoelace-rails"

Turbolinks.start()
startUjs()
startTurbolinks(Turbolinks)
