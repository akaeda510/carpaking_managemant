import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	connect () {
		setTimeout(() => {
		const chart = Chartkick.charts["occupancy-chart"]
		if (chart) {
			const chartInstance = chart.getChartObject()
			chartInstance.options.scales.x.ticks.callback = function(value, index) {
				const label = this.getLabelForValue(value)
				console.log("label:", label)
				const date = new Date(label)
				const now = new Date()

				if(
					date.getFullYear() === now.getFullYear() &&
					date.getMonth() === now.getMonth()
				) {
					return "今月"
				}
				return date.getFullYear() + "/" + (date.getMonth() + 1)
			}
			chartInstance.update()
		}
		}, 500)
	}
}
