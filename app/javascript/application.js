import "@hotwired/turbo-rails"
import "./controllers"
import { PasswordToggle } from "./utils/password_toggle"
import { PasswordValidator } from "./utils/password_validator"

const initUtils = () => {
	PasswordToggle.init();
	PasswordValidator.init();
};

document.addEventListener("turbo:load", initUtils);
document.addEventListener('turbo:render', initUtils);
