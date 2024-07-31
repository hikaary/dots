// ==UserScript==
// @name         SponsorBlock для Min Browser (Исправленная версия)
// @namespace    http://tampermonkey.net/
// @version      6.2
// @description  Пропуск различных типов сегментов с использованием стандартного fetch API
// @match        https://www.youtube.com/*
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';

    const DEBUG = false;
    let isInitialized = false;
    let segments = [];
    let currentVideoId = '';
    let lastSkippedSegments = new Set();

    const API_BASE_URL = 'https://sponsor.ajay.app/api/skipSegments';

    const CATPPUCCIN_COLORS = {
        red: '#F28FAD',
        peach: '#F8BD96',
        green: '#ABE9B3',
        blue: '#96CDFB',
        mauve: '#DDB6F2',
        pink: '#F5C2E7',
        yellow: '#FAE3B0',
        teal: '#B5E8E0',
        text: '#D9E0EE',
        base: '#1E1E2E',
        mantle: '#1A1826',
    };

    const SEGMENT_TYPES = {
        sponsor: { color: CATPPUCCIN_COLORS.peach, label: 'Спонсорская реклама' },
        selfpromo: { color: CATPPUCCIN_COLORS.blue, label: 'Самопиар' },
        interaction: { color: CATPPUCCIN_COLORS.green, label: 'Призыв к действию' },
        intro: { color: CATPPUCCIN_COLORS.mauve, label: 'Вступительная заставка' },
        outro: { color: CATPPUCCIN_COLORS.pink, label: 'Завершающая заставка' },
        preview: { color: CATPPUCCIN_COLORS.yellow, label: 'Превью/анонс' },
        music_offtopic: { color: CATPPUCCIN_COLORS.teal, label: 'Нерелевантная музыка' },
        filler: { color: CATPPUCCIN_COLORS.red, label: 'Пустая болтовня' }
    };

    function log(message) {
        if (DEBUG) {
            console.log(`[SponsorBlock] ${message}`);
        }
    }

    async function fetchSponsorData(videoId) {
        log(`Получение данных о сегментах для видео: ${videoId}`);
        const categoriesJson = JSON.stringify(Object.keys(SEGMENT_TYPES));
        const params = new URLSearchParams({
            videoID: videoId,
            categories: categoriesJson
        });

        const url = `${API_BASE_URL}?${params}`;
        log(`Запрос к API: ${url}`);

        try {
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            segments = await response.json();
            log(`Получены сегменты: ${JSON.stringify(segments)}`);
            visualizeSegments();
        } catch (error) {
            log(`Ошибка при получении данных: ${error.message}`);
        }
    }

    function visualizeSegments() {
        log('Начало визуализации сегментов');
        const progressBar = document.querySelector('.ytp-progress-bar');
        if (!progressBar) {
            log('Элемент прогресс-бара не найден');
            return;
        }

        document.querySelectorAll('.sponsorblock-segment').forEach(el => el.remove());

        let segmentContainer = document.querySelector('.sponsorblock-segment-container');
        if (!segmentContainer) {
            segmentContainer = document.createElement('div');
            segmentContainer.className = 'sponsorblock-segment-container';
            progressBar.appendChild(segmentContainer);
            log('Создан новый контейнер для сегментов');
        }

        const video = document.querySelector('video');
        if (!video) {
            log('Элемент video не найден');
            return;
        }
        const videoDuration = video.duration;
        log(`Длительность видео: ${videoDuration}`);

        segments.forEach((segment, index) => {
            const segmentElement = document.createElement('div');
            segmentElement.className = 'sponsorblock-segment';

            const startPercent = (segment.segment[0] / videoDuration) * 100;
            const endPercent = (segment.segment[1] / videoDuration) * 100;

            segmentElement.style.left = `${startPercent}%`;
            segmentElement.style.width = `${endPercent - startPercent}%`;
            segmentElement.style.backgroundColor = SEGMENT_TYPES[segment.category].color;
            
            const tooltipText = `${SEGMENT_TYPES[segment.category].label}: ${formatTime(segment.segment[0])} - ${formatTime(segment.segment[1])}`;
            segmentElement.setAttribute('data-tooltip', tooltipText);

            segmentContainer.appendChild(segmentElement);
            log(`Добавлен сегмент ${index + 1}: ${tooltipText}`);
        });
    }

    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = Math.floor(seconds % 60);
        return `${minutes}:${remainingSeconds < 10 ? '0' : ''}${remainingSeconds}`;
    }

    function checkForSegments() {
        const video = document.querySelector('video');
        if (!video) {
            log('Элемент video не найден в checkForSegments');
            return;
        }

        const currentTime = video.currentTime;
        log(`Текущее время видео: ${currentTime}`);

        for (let segment of segments) {
            if (currentTime >= segment.segment[0] && currentTime < segment.segment[1]) {
                const segmentId = `${segment.category}-${segment.segment[0]}-${segment.segment[1]}`;
                if (!lastSkippedSegments.has(segmentId)) {
                    log(`Пропуск сегмента ${segment.category}: ${segment.segment[0]} - ${segment.segment[1]}`);
                    video.currentTime = segment.segment[1];
                    showSkipNotification(segment);
                    lastSkippedSegments.add(segmentId);
                }
                break;
            }
        }
    }

    function showSkipNotification(segment) {
        const notification = document.createElement('div');
        notification.className = 'sponsorblock-notification';
        notification.textContent = `Пропущен сегмент: ${SEGMENT_TYPES[segment.category].label} (${formatTime(segment.segment[1] - segment.segment[0])})`;
        notification.style.backgroundColor = SEGMENT_TYPES[segment.category].color;
        document.body.appendChild(notification);
        log(`Показано уведомление: ${notification.textContent}`);

        setTimeout(() => {
            notification.style.opacity = '0';
            setTimeout(() => notification.remove(), 500);
        }, 3000);
    }

    function getVideoId() {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get('v');
    }

    function init() {
        if (isInitialized) return;
        log('Инициализация скрипта SponsorBlock');
        const videoId = getVideoId();
        if (videoId && videoId !== currentVideoId) {
            currentVideoId = videoId;
            fetchSponsorData(videoId);
            lastSkippedSegments.clear();
        }

        const video = document.querySelector('video');
        if (video) {
            log('Добавление слушателя события timeupdate к видео');
            video.addEventListener('timeupdate', checkForSegments);
        } else {
            log('Элемент video не найден при инициализации');
        }
        isInitialized = true;
    }

    const style = document.createElement('style');
    style.textContent = `
        .sponsorblock-segment-container {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100%;
            pointer-events: none;
            z-index: 25;
        }
        .sponsorblock-segment {
            position: absolute;
            top: 0;
            height: 100%;
            transition: all 0.2s ease-in-out;
        }
        .ytp-progress-bar:hover .sponsorblock-segment {
            opacity: 1;
            height: 140%;
            top: -20%;
        }
        .sponsorblock-segment:hover::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background-color: ${CATPPUCCIN_COLORS.base};
            color: ${CATPPUCCIN_COLORS.text};
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            white-space: nowrap;
            z-index: 1000;
            pointer-events: none;
        }
        .sponsorblock-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            color: ${CATPPUCCIN_COLORS.base};
            padding: 10px 15px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            z-index: 9999;
            transition: opacity 0.5s ease-in-out;
        }
    `;
    document.head.appendChild(style);

    function waitForVideo() {
        const video = document.querySelector('video');
        if (video) {
            init();
        } else {
            setTimeout(waitForVideo, 100);
        }
    }

    window.addEventListener('yt-navigate-finish', () => {
        log('Событие yt-navigate-finish сработало');
        isInitialized = false;
        waitForVideo();
    });

    waitForVideo();

    log('Скрипт SponsorBlock загружен и готов к работе');
})();
