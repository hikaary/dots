// ==UserScript==
// @name         Advanced Universal Catppuccin Dark Mode for Min Browser
// @namespace    http://tampermonkey.net/
// @version      4.1
// @description  Advanced dark mode adhering to Catppuccin Mocha theme with support for glow, shadows, and transparency
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

    // Catppuccin Mocha color palette
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

    function getCurrentDomain() {
        return location.hostname;
    }

    function isIgnoredSite() {
        return ignoredSites.some(site => getCurrentDomain().includes(site));
    }

    function getDarkModeState() {
        const domain = getCurrentDomain();
        const state = localStorage.getItem(`catppuccin_dark_mode_${domain}`);
        return state === null ? true : state === 'true';
    }

    function setDarkModeState(enabled) {
        const domain = getCurrentDomain();
        localStorage.setItem(`catppuccin_dark_mode_${domain}`, enabled);
    }

    function hexToRGB(hex) {
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        return {r, g, b};
    }

    function rgbToHSL(r, g, b) {
        r /= 255;
        g /= 255;
        b /= 255;
        const max = Math.max(r, g, b);
        const min = Math.min(r, g, b);
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

    function hslToRGB(h, s, l) {
        h /= 360;
        s /= 100;
        l /= 100;
        let r, g, b;

        if (s === 0) {
            r = g = b = l;
        } else {
            const hue2rgb = (p, q, t) => {
                if (t < 0) t += 1;
                if (t > 1) t -= 1;
                if (t < 1/6) return p + (q - p) * 6 * t;
                if (t < 1/2) return q;
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
                return p;
            };

            const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            const p = 2 * l - q;
            r = hue2rgb(p, q, h + 1/3);
            g = hue2rgb(p, q, h);
            b = hue2rgb(p, q, h - 1/3);
        }

        return {
            r: Math.round(r * 255),
            g: Math.round(g * 255),
            b: Math.round(b * 255)
        };
    }

    function mixColors(color1, color2, weight = 0.5) {
        const w = 2 * weight - 1;
        const a = 0;

        const w1 = (((w * a === -1) ? w : (w + a) / (1 + w * a)) + 1) / 2;
        const w2 = 1 - w1;

        return {
            r: Math.round(color1.r * w1 + color2.r * w2),
            g: Math.round(color1.g * w1 + color2.g * w2),
            b: Math.round(color1.b * w1 + color2.b * w2)
        };
    }

    function mapColor(color, isBackground = false) {
        if (!color || color === 'transparent') return isBackground ? catppuccinMocha.base : catppuccinMocha.text;
        
        let rgb = color.startsWith('#') ? hexToRGB(color) : {
            r: parseInt(color.split(',')[0].slice(4)),
            g: parseInt(color.split(',')[1]),
            b: parseInt(color.split(',')[2])
        };

        let hsl = rgbToHSL(rgb.r, rgb.g, rgb.b);

        if (isBackground) {
            hsl.l = Math.max(5, Math.min(30, hsl.l)); // Adjust lightness for dark mode
            hsl.s = Math.min(hsl.s, 30); // Reduce saturation for backgrounds
        } else {
            hsl.l = Math.max(60, Math.min(90, hsl.l)); // Adjust lightness for text
            hsl.s = Math.min(hsl.s, 70); // Slightly reduce saturation for text
        }

        let newRgb = hslToRGB(hsl.h, hsl.s, hsl.l);
        let baseColor = isBackground ? hexToRGB(catppuccinMocha.base) : hexToRGB(catppuccinMocha.text);
        let mixedColor = mixColors(newRgb, baseColor, 0.7); // Mix with Catppuccin colors

        return `rgb(${mixedColor.r}, ${mixedColor.g}, ${mixedColor.b})`;
    }

    function adjustShadow(shadowValue) {
        if (!shadowValue || shadowValue === 'none') return 'none';

        const shadows = shadowValue.match(/([rgba]?\([^)]+\)|\S+)/g);
        return shadows.map(shadow => {
            const parts = shadow.split(' ');
            const color = parts.find(part => part.startsWith('rgb') || part.startsWith('#'));
            if (color) {
                const mappedColor = mapColor(color, true);
                return shadow.replace(color, mappedColor);
            }
            return shadow;
        }).join(', ');
    }

    function adjustGlow(glowValue) {
        if (!glowValue || glowValue === 'none') return 'none';

        const glows = glowValue.match(/([rgba]?\([^)]+\)|\S+)/g);
        return glows.map(glow => {
            const parts = glow.split(' ');
            const color = parts.find(part => part.startsWith('rgb') || part.startsWith('#'));
            if (color) {
                const mappedColor = mapColor(color, false);
                return glow.replace(color, mappedColor);
            }
            return glow;
        }).join(', ');
    }

    function adjustTransparency(color) {
        if (!color.startsWith('rgba')) return color;

        const parts = color.match(/[\d.]+/g);
        if (parts.length === 4) {
            const rgb = mapColor(`rgb(${parts[0]}, ${parts[1]}, ${parts[2]})`);
            return rgb.replace('rgb', 'rgba').replace(')', `, ${parts[3]})`);
        }
        return color;
    }

    function modifyColors() {
        const elementsToModify = document.querySelectorAll('*');

        elementsToModify.forEach(el => {
            const style = window.getComputedStyle(el);
            const backgroundColor = style.backgroundColor;
            const color = style.color;
            const boxShadow = style.boxShadow;
            const textShadow = style.textShadow;

            if (backgroundColor && backgroundColor !== 'rgba(0, 0, 0, 0)' && backgroundColor !== 'transparent') {
                const mappedBg = adjustTransparency(mapColor(backgroundColor, true));
                el.style.setProperty('background-color', mappedBg, 'important');
            }
            
            if (color) {
                const mappedColor = adjustTransparency(mapColor(color));
                el.style.setProperty('color', mappedColor, 'important');
            }

            if (boxShadow && boxShadow !== 'none') {
                const adjustedBoxShadow = adjustShadow(boxShadow);
                el.style.setProperty('box-shadow', adjustedBoxShadow, 'important');
            }

            if (textShadow && textShadow !== 'none') {
                const adjustedTextShadow = adjustGlow(textShadow);
                el.style.setProperty('text-shadow', adjustedTextShadow, 'important');
            }

            // Handle specific elements
            if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                el.style.setProperty('background-color', catppuccinMocha.surface0, 'important');
                el.style.setProperty('color', catppuccinMocha.text, 'important');
                el.style.setProperty('border-color', catppuccinMocha.overlay0, 'important');
            }
        });
    }

    let darkModeEnabled = getDarkModeState();

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
        // Reset all element styles
        document.querySelectorAll('*').forEach(el => {
            el.style.removeProperty('background-color');
            el.style.removeProperty('color');
            el.style.removeProperty('border-color');
            el.style.removeProperty('box-shadow');
            el.style.removeProperty('text-shadow');
        });
    }

    function applyDarkMode() {
        if (darkModeEnabled && !isIgnoredSite()) {
            createOrUpdateStyle(`
                html, body {
                    background-color: ${catppuccinMocha.base} !important;
                    color: ${catppuccinMocha.text} !important;
                }
                a {
                    color: ${catppuccinMocha.blue} !important;
                }
                a:hover {
                    color: ${catppuccinMocha.sapphire} !important;
                }
                ::placeholder {
                    color: ${catppuccinMocha.overlay1} !important;
                }
                ::-webkit-scrollbar {
                    background-color: ${catppuccinMocha.mantle};
                }
                ::-webkit-scrollbar-thumb {
                    background-color: ${catppuccinMocha.surface1};
                }
            `);
            modifyColors();
        } else {
            removeStyle();
        }
    }

    function toggleDarkMode() {
        darkModeEnabled = !darkModeEnabled;
        setDarkModeState(darkModeEnabled);
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

    // Initialize
    if (!isIgnoredSite()) {
        applyDarkMode();

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
