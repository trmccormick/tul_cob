import { Controller } from "@hotwired/stimulus"

  function getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }

  export default class extends Controller {
    static targets = [  "results" ]

    initialize() {
      fetch(this.data.get("url"), {
        credentials: "same-origin",
        headers: { "X-CSRF-Token": getMetaValue("csrf-token") },
      })
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
        $(".query-heading").removeClass("hidden");
        $(".query-feedback").removeClass("hidden");
        $("#related-items-link").removeClass("hidden");
      })
  }
}
