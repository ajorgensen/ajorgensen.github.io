document.addEventListener('DOMContentLoaded', function() {
    setupToggle();

    const theme = currentTheme()
    applyTheme(theme);

    updateToggleText();
}, false);

function setupToggle() {
    var toggle = document.getElementById('theme-toggle');
    toggle.addEventListener("click", toggleTheme)
}

function currentTheme() {
    const prefersDarkScheme = window.matchMedia("(prefers-color-scheme: dark)");
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
    const theme = currentTheme()

    if (theme === "dark") {
        localStorage.theme = "light"
        applyTheme("light")
    } else {
        localStorage.theme = "dark"
        applyTheme("dark")
    }

    updateToggleText()
}

function applyTheme(t) {
    if (t === "dark") {
        document.documentElement.classList.add('dark')
    } else if (t === "light") {
        document.documentElement.classList.remove('dark')
    }
}