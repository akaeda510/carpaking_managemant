export class PasswordToggle {
	static init(): void {
		document.addEventListener('click', (event: MouseEvent) => {
			const button = (event.target as HTMLElement).closest<HTMLButtonElement>('[data-password-toggle-target]');
			if (!button) return;

			const targetId = button.dataset.passwordToggleTarget;
			if (!targetId) return;

			const input = document.getElementById(targetId) as HTMLInputElement | null;
			if (!input) return;

			const isPassword = input.type === 'password';
			input.type = isPassword ? 'text' : 'password';

			this.toggleIcon(button, isPassword);
		});
	}

	private static toggleIcon(button: HTMLButtonElement, isVisible: boolean): void {
		const icon = button.querySelector('svg');
		if (!icon) return;

		if (isVisible) {
			button.classList.add('text-indigo-600');
		} else {
			button.classList.remove('text-indigo-600');
		}
	}
}

