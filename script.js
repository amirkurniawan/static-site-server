// Google KW - Simple Search Redirect

document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-input');
    const searchForm = document.querySelector('.search-form');

    // Focus animation
    searchInput.addEventListener('focus', function() {
        document.querySelector('.search-box').style.boxShadow = '0 1px 6px rgba(32, 33, 36, 0.28)';
    });

    searchInput.addEventListener('blur', function() {
        document.querySelector('.search-box').style.boxShadow = '';
    });

    // Form validation
    searchForm.addEventListener('submit', function(e) {
        if (searchInput.value.trim() === '') {
            e.preventDefault();
            searchInput.focus();
        }
    });

    // Voice search placeholder (just alert for demo)
    document.querySelector('.voice-icon').addEventListener('click', function() {
        alert('Fitur penelusuran suara akan tersedia segera di Google KW!');
    });

    // Camera search placeholder
    document.querySelector('.camera-icon').addEventListener('click', function() {
        alert('Fitur penelusuran gambar akan tersedia segera di Google KW!');
    });

    // Console easter egg
    console.log('%c Google KW ', 'background: #4285f4; color: white; font-size: 24px; font-weight: bold;');
    console.log('%c Powered by Nginx + rsync ', 'color: #34a853; font-size: 12px;');
    console.log('%c DevOps Project - roadmap.sh ', 'color: #ea4335; font-size: 12px;');
});

// Keyboard shortcut: Press "/" to focus search
document.addEventListener('keydown', function(e) {
    if (e.key === '/' && document.activeElement.tagName !== 'INPUT') {
        e.preventDefault();
        document.querySelector('.search-input').focus();
    }
});
