import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = [ "selection", "additionalFields" ]

  initialize() {
    this.showAdditionalFields()
  }

  showAdditionalFields() {
    const selection = this.selectionTarget.value

    this.additionalFieldsTargets.forEach((field) => {
      if (field.dataset.type === selection) {
        field.disabled = false
        field.style.display = ""
      } else {
        field.disabled = true
        field.style.display = "none"
      }
    })
  }
}
