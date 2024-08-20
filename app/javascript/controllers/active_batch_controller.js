import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="active-batch"
export default class extends Controller {
  static targets = ["link"];

  highlight(event) {
    // remove active from all the other links
    this.linkTargets.forEach((link) => {
      link.classList.remove("active");
    });
    event.currentTarget.classList.add("active");
  }
}
