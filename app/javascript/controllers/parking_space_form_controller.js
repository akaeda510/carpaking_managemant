import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["garageFields"]

	connect() {
		console.log("ParkingSpaceForm controller connected!");
	}

	toggle() {
		console.log("Radio button changed!");
		const radio = this.element.querySelector('input[type="radio"]:checked')

		if (!radio) return

		const.log("Selected Type:", radio.value)

		if (radio.value === 'garage') {
			this.garageFieldsTarget.classList.remove('hidden')
		} else {
			this.garageFieldsTarget.classList.add('hidden')
		}
	}
}
