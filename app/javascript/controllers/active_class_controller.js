import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="active-class"
export default class extends Controller {
  static targets = ["link"];

  update(event) {
    // remove the active class
    this.linkTargets.forEach((link) => {
      link.classList.remove("active");
    });
    // add to the current one
    event.currentTarget.classList.add("active");
  }
}
