import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["input"]
	declare readonly inputTargets: HTMLInputElement[]

	connect() {
    console.log("Cまる！オートフォーカスが接続されました");
    console.log("ターゲットの数:", this.inputTargets.length);
  }

	next(event: Event): void {
		console.log("文字が入力されました！");
		const input = event.target as HTMLInputElement
		if (input.value.length >= input.maxLength) {
			const index = this.inputTargets.indexOf(input)
			this.inputTargets[index + 1]?.focus()
		}
	}

	previous(event: KeyboardEvent): void {
		const input = event.target as HTMLInputElement
		if (event.key === "Backspace" && input.value.length === 0) {
			const index = this.inputTargets.indexOf(input)
			this.inputTargets[index - 1]?.focus()
		}
	}
}
