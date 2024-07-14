// ==UserScript==
// @name         Universal Catppuccin Dark Mode for Min Browser
// @namespace    http://tampermonkey.net/
// @version      2.1
// @description  Advanced dark mode with Catppuccin Mocha theme, inspired by Dark Reader, with ignored sites
// @match        *://*/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // List of sites to ignore (add your sites here)
    const ignoredSites = [
        'google.com',
        'www.youtube.com',
        'claude.ai',
    ];

    // Function to check if the current site should be ignored
    function isIgnoredSite() {
        return ignoredSites.some(site => location.hostname.includes(site));
    }

    const catppuccinMocha = {
        base: '#1e1e2e',
        mantle: '#181825',
        crust: '#11111b',
        text: '#cdd6f4',
        subtext1: '#bac2de',
        subtext0: '#a6adc8',
        overlay2: '#9399b2',
        overlay1: '#7f849c',
        overlay0: '#6c7086',
        surface2: '#585b70',
        surface1: '#45475a',
        surface0: '#313244',
        blue: '#89b4fa',
        lavender: '#b4befe',
        sapphire: '#74c7ec',
        sky: '#89dceb',
        teal: '#94e2d5',
        green: '#a6e3a1',
        yellow: '#f9e2af',
        peach: '#fab387',
        maroon: '#eba0ac',
        red: '#f38ba8',
        mauve: '#cba6f7',
        pink: '#f5c2e7',
        flamingo: '#f2cdcd',
        rosewater: '#f5e0dc'
    };

    function hexToRGB(hex) {
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        return {r, g, b};
    }

    function RGBToHSL({r, g, b}) {
        r /= 255; g /= 255; b /= 255;
        const max = Math.max(r, g, b), min = Math.min(r, g, b);
        let h, s, l = (max + min) / 2;

        if (max === min) {
            h = s = 0;
        } else {
            const d = max - min;
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
            switch (max) {
                case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                case g: h = (b - r) / d + 2; break;
                case b: h = (r - g) / d + 4; break;
            }
            h /= 6;
        }
        return {h: h * 360, s: s * 100, l: l * 100};
    }

    function HSLToRGB({h, s, l}) {
        s /= 100; l /= 100;
        const k = n => (n + h / 30) % 12;
        const a = s * Math.min(l, 1 - l);
        const f = n => l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));
        return {
            r: Math.round(255 * f(0)),
            g: Math.round(255 * f(8)),
            b: Math.round(255 * f(4))
        };
    }

    function modifyColor(color, backgroundIsDark) {
        if (color.startsWith('rgba')) {
            const [r, g, b, a] = color.match(/\d+(\.\d+)?/g).map(Number);
            const hsl = RGBToHSL({r, g, b});
            if (backgroundIsDark) {
                hsl.l = Math.min(100, hsl.l + 40);
            } else {
                hsl.l = Math.max(0, hsl.l - 40);
            }
            const {r: newR, g: newG, b: newB} = HSLToRGB(hsl);
            return `rgba(${newR}, ${newG}, ${newB}, ${a})`;
        } else {
            const hsl = RGBToHSL(hexToRGB(color));
            if (backgroundIsDark) {
                hsl.l = Math.min(100, hsl.l + 40);
            } else {
                hsl.l = Math.max(0, hsl.l - 40);
            }
            const {r, g, b} = HSLToRGB(hsl);
            return `rgb(${r}, ${g}, ${b})`;
        }
    }

    function createCatppuccinStyle() {
        return `
            html, body, input, textarea, select, button {
                background-color: ${catppuccinMocha.base} !important;
                color: ${catppuccinMocha.text} !important;
                border-color: ${catppuccinMocha.overlay0} !important;
                transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease !important;
            }
            a {
                color: ${catppuccinMocha.blue} !important;
                transition: color 0.3s ease !important;
            }
            a:hover {
                color: ${catppuccinMocha.sapphire} !important;
            }
            :root {
                --darkreader-neutral-background: ${catppuccinMocha.base};
                --darkreader-neutral-text: ${catppuccinMocha.text};
                --darkreader-selection-background: ${catppuccinMocha.surface2};
                --darkreader-selection-text: ${catppuccinMocha.text};
            }
            html {
                background-image: none !important;
            }
            html, body, body :not(iframe):not(div[style^="position:absolute;top:0;left:-"]) {
                background-color: var(--darkreader-neutral-background) !important;
                border-color: var(--darkreader-neutral-text) !important;
                color: var(--darkreader-neutral-text) !important;
                transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease !important;
            }
            input, textarea, select, button {
                background-color: ${catppuccinMocha.surface0} !important;
            }
            ::placeholder {
                color: ${catppuccinMocha.overlay1} !important;
            }
            ::selection {
                background-color: var(--darkreader-selection-background) !important;
                color: var(--darkreader-selection-text) !important;
            }
            ::-moz-selection {
                background-color: var(--darkreader-selection-background) !important;
                color: var(--darkreader-selection-text) !important;
            }
        `;
    }

    function modifyColors() {
        const elementsToModify = document.querySelectorAll('*');
        const baseHSL = RGBToHSL(hexToRGB(catppuccinMocha.base));
        const isDark = baseHSL.l < 50;

        elementsToModify.forEach(el => {
            const style = window.getComputedStyle(el);
            const backgroundColor = style.backgroundColor;
            const color = style.color;

            if (backgroundColor && backgroundColor !== 'rgba(0, 0, 0, 0)' && backgroundColor !== 'transparent') {
                el.style.setProperty('background-color', modifyColor(backgroundColor, isDark), 'important');
                el.style.setProperty('transition', 'background-color 0.3s ease', 'important');
            }
            if (color) {
                el.style.setProperty('color', modifyColor(color, !isDark), 'important');
                el.style.setProperty('transition', 'color 0.3s ease', 'important');
            }
        });
    }

    let darkModeEnabled = false;

    function createOrUpdateStyle(css) {
        let style = document.getElementById('catppuccin-dark-mode-style');
        if (!style) {
            style = document.createElement('style');
            style.id = 'catppuccin-dark-mode-style';
            style.classList.add('catppuccin');
            document.documentElement.appendChild(style);
        }
        if (css.replace(/^\s+/gm, '') !== style.textContent.replace(/^\s+/gm, '')) {
            style.textContent = css;
        }
    }

    function removeStyle() {
        const style = document.getElementById('catppuccin-dark-mode-style');
        if (style) {
            style.remove();
        }
    }

    function applyDarkMode() {
        if (darkModeEnabled && !isIgnoredSite()) {
            createOrUpdateStyle(createCatppuccinStyle());
            modifyColors();
        } else {
            removeStyle();
        }
    }

    function toggleDarkMode() {
        darkModeEnabled = !darkModeEnabled;
        applyDarkMode();
        showStatus();
    }

    function showStatus() {
        let status = document.createElement('div');
        status.textContent = `Catppuccin Dark Mode: ${darkModeEnabled ? (isIgnoredSite() ? 'On (Site Ignored)' : 'On') : 'Off'}`;
        status.style.cssText = `
            position: fixed;
            bottom: 10px;
            right: 10px;
            padding: 5px 10px;
            background-color: ${catppuccinMocha.surface0};
            color: ${catppuccinMocha.text};
            border-radius: 5px;
            font-family: Arial, sans-serif;
            font-size: 12px;
            z-index: 2147483647;
        `;
        document.body.appendChild(status);
        setTimeout(() => document.body.removeChild(status), 2000);
    }

    function isSystemDarkModeEnabled() {
        return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    }

    function runColorSchemeChangeDetector(callback) {
        if (window.matchMedia) {
            const matcher = window.matchMedia('(prefers-color-scheme: dark)');
            matcher.addListener((e) => callback(e.matches));
        }
    }

    function notifyOfColorScheme(isDark) {
        console.log(`System color scheme changed to ${isDark ? 'dark' : 'light'}`);
        darkModeEnabled = isDark;
        applyDarkMode();
    }

    // Initialize
    if (!isIgnoredSite()) {
        darkModeEnabled = isSystemDarkModeEnabled();
        applyDarkMode();

        // Watch for system color scheme changes
        runColorSchemeChangeDetector(notifyOfColorScheme);

        // Add toggle hotkey (Ctrl+Alt+D)
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey && e.altKey && e.key === 'd') {
                toggleDarkMode();
            }
        });

        // Observe DOM changes to reapply styles if necessary
        const observer = new MutationObserver((mutations) => {
            if (darkModeEnabled) {
                mutations.forEach(mutation => {
                    if (mutation.type === 'childList') {
                        mutation.addedNodes.forEach(node => {
                            if (node.nodeType === 1) { // ELEMENT_NODE
                                modifyColors();
                            }
                        });
                    }
                });
            }
        });
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        // Apply styles when DOM is ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', applyDarkMode);
        } else {
            applyDarkMode();
        }
    }
})();
