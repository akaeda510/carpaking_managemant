import "@hotwired/turbo-rails"
import "./controllers"
import { PasswordToggle } from "./utils/password_toggle"
import { PasswordValidator } from "./utils/password_validator"

document.addEventListener("turbo:load", () => {
	PasswordToggle.init();
	PasswordValidator.init();
});
