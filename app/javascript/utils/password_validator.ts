export class PasswordValidator {
	static init(): void {
		const field = document.getElementById('password_field') as HTMLInputElement;
		const hint = document.getElementById('password_hint');
		if (!field || !hint) return;

		field.addEventListener('input', () => {
			const length = field.value.length;
			if (length >= 6) {
				hint.classList.replace('text-gray-500', 'text-green-600');
				hint.innerText = "✔ 6文字以上記入しています";
			} else {
				hint.classList.replace('text-green-600', 'text-gray-500');
				hint.innerText = "6文字以上記入してください";
			}
		});
	}
}					    
