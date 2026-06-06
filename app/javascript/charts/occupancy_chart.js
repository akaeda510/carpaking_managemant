export const occupancyChartOptions = {
	scales: {
		x: {
			ticks: {
				callback: function(value) {
					const date = new Date(value)
					const now = new Date()
					if(
						date.getFullYear() === now.getFullYear() &&
						date.getMonth() === now.getMonth()
					) {
						return "今月"
					}
					return date.getFullYear() + "/" + (date.getMonth() + 1)
				}
			}
		}
	}
}
