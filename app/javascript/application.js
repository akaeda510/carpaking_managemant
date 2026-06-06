import "@hotwired/turbo-rails"
import "./controllers"
import "chartkick/chart.js"
import { PasswordToggle } from "./utils/password_toggle"
import { PasswordValidator } from "./utils/password_validator"
import { occupancyChartOptions } from "./charts/occupancy_chart"

const initUtils = () => {
	PasswordToggle.init();
	PasswordValidator.init();
};

document.addEventListener("turbo:load", () => { 
	initUtils()
	const chart = Chartkick.charts["occupancy-chart"]
	if (chart) {
		chart.updateOptions(occupancyChartOptions) } 
});
document.addEventListener("turbo:render", initUtils);
