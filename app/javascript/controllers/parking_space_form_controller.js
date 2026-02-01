import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["garageFields"]

	toggle() {
		const selectedType = this.element.querySelector('input[name="parking_space[parking_type]"]:checkes').value

		if (selectedType === 'garage') {
			this.garageFieldsTarget.classLimit.remove('hidden')
		} else {
			this.garageFieldsTarget.classList.add('hiden')
		}
	}
}
