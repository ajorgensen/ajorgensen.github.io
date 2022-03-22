document.addEventListener('DOMContentLoaded', function() {
    setupToggle();
    applyTheme();
}, false);

function setupToggle() {
    var toggle = document.getElementById('theme-toggle');
    toggle.addEventListener("click", toggleTheme)
    updateToggleText()
}

function updateToggleText() {
    var toggle = document.getElementById('theme-toggle');
    const theme = currentTheme()

    if (theme === "dark") {
        toggle.innerText = "Light Theme"; 
    } else {
        toggle.innerText = "Dark Theme"; 
    }
}

function toggleTheme() {
    var body = document.body; 
    const theme = currentTheme()

    if (theme === "dark") {
        body.classList.remove('dark-mode');
        localStorage.setItem("theme", "light")
    } else {
        body.classList.add('dark-mode');
        localStorage.setItem("theme", "dark")
    }

    updateToggleText()
    applyTheme()
}

function currentTheme() {
    const theme = localStorage.getItem("theme")

    if (theme) {
        return theme;
    }

    if (prefersDarkScheme.matches) {
        return "dark";
    } else {
        return "light";
    }
}

function applyTheme() {
    var body = document.body; 
    const prefersDarkScheme = window.matchMedia("(prefers-color-scheme: dark)");
    const theme = localStorage.getItem("theme")

    if (theme && theme === "dark") {
        body.classList.add('dark-mode');
        return
    } else if (theme && theme === "light") {
        body.classList.remove('dark-mode');
        return
    }

    if (prefersDarkScheme.matches) {
        body.classList.add('dark-mode');
    } else {
        body.classList.remove('dark-mode');
    }
}