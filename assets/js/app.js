// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

let Hooks = {}
Hooks.RTT = {
    mounted() {
        this.timer = setInterval(() => {
            let beforeTime = (new Date().getTime())
            this.pushEvent("ping", {}, resp => {
                let rtt = (new Date().getTime()) - beforeTime
                this.el.innerText = `${rtt}ms`
            })
        }, 1000)
    },
    destroyed() { clearInterval(this.timer) }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    params: { _csrf_token: csrfToken },
    hooks: Hooks,
    metadata: {
        keydown: (e, el) => {
            return {
                key: e.key,
                value: el.value,
            }
        }
    }
})

// Show progress bar on live navigation and form submits
// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

