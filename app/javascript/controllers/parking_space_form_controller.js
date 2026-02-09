import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["garageFields"]

  connect() {
    this.toggle()
  }

  toggle() {
    if (!this.hasGarageFieldsTarget) return

    const radio = document.querySelector('input[name="parking_space[parking_type]"]:checked')
    const selectedType = radio ? radio.value : null

    if (selectedType === 'garage') {
      this.garageFieldsTarget.style.display = "block"
      this.garageFieldsTarget.classList.remove('hidden')
    } else {
      this.garageFieldsTarget.style.display = "none"
      this.garageFieldsTarget.classList.add('hidden')
    }
  }
}
