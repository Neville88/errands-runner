document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-dismiss-alert]').forEach((button) => {
        button.addEventListener('click', () => {
            const alert = button.closest('[data-alert]');
            if (alert) {
                alert.remove();
            }
        });
    });

    document.querySelectorAll('[data-confirm]').forEach((element) => {
        element.addEventListener('click', (event) => {
            const message = element.getAttribute('data-confirm') || 'Are you sure you want to continue?';
            if (!window.confirm(message)) {
                event.preventDefault();
            }
        });
    });

    const revealTargets = document.querySelectorAll(
        'main article, main .shadow-sm, main .shadow-lg, main .rounded-\\[2rem\\], main table'
    );

    if ('IntersectionObserver' in window) {
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('reveal-on-scroll', 'is-visible');
                        observer.unobserve(entry.target);
                    }
                });
            },
            {
                threshold: 0.12,
                rootMargin: '0px 0px -40px 0px',
            }
        );

        revealTargets.forEach((element) => {
            element.classList.add('reveal-on-scroll');
            observer.observe(element);
        });
    }
});