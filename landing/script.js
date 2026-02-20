document.addEventListener('DOMContentLoaded', () => {
    // Initialize Lucide Icons
    lucide.createIcons();

    // Scroll Reveal System
    const reveals = document.querySelectorAll('.reveal, .mockup-reveal');

    const revealOnScroll = () => {
        const triggerBottom = window.innerHeight * 0.9;

        reveals.forEach(el => {
            const top = el.getBoundingClientRect().top;
            if (top < triggerBottom) {
                el.classList.add('visible');
            }
        });

        // Navbar effect
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    };

    window.addEventListener('scroll', revealOnScroll);
    revealOnScroll(); // Initial check

    // Smooth reveal for bento items with stagger
    const bentoItems = document.querySelectorAll('.bento-item');
    bentoItems.forEach((item, index) => {
        item.style.transitionDelay = `${index * 0.1}s`;
    });

    // Simple interaction feedback for APK btn
    const apkBtn = document.querySelector('.download-link.apk');
    apkBtn.addEventListener('click', (e) => {
        if (apkBtn.getAttribute('href') === '#') {
            e.preventDefault();
            const originalText = apkBtn.querySelector('.bottom').textContent;
            apkBtn.querySelector('.bottom').textContent = 'Wait for it...';
            setTimeout(() => {
                alert('APK download link will be inserted here.');
                apkBtn.querySelector('.bottom').textContent = originalText;
            }, 500);
        }
    });

    // Parallax for noise
    window.addEventListener('mousemove', (e) => {
        const x = e.clientX / window.innerWidth;
        const y = e.clientY / window.innerHeight;
        const noise = document.querySelector('.noise-overlay');
        noise.style.transform = `translate(${x * 10}px, ${y * 10}px)`;
    });
});
