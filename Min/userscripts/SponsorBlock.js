// ==UserScript==
// @name         SponsorBlock for Min Browser (Improved Visual)
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Skip and visualize sponsor segments directly on YouTube video progress bar
// @match        https://www.youtube.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    let sponsorSegments = [];
    let currentVideoId = '';

    function log(message) {
        console.log(`[SponsorBlock] ${message}`);
    }

    function fetchSponsorData(videoId) {
        log(`Fetching sponsor data for video: ${videoId}`);
        fetch(`https://sponsor.ajay.app/api/skipSegments?videoID=${videoId}`)
            .then(response => response.json())
            .then(data => {
                sponsorSegments = data;
                log(`Received sponsor segments: ${JSON.stringify(sponsorSegments)}`);
                visualizeSegments();
            })
            .catch(error => log(`Error fetching sponsor data: ${error}`));
    }

    function visualizeSegments() {
        const progressBar = document.querySelector('.ytp-progress-bar');
        if (!progressBar) return;

        // Remove existing segment visualizations
        document.querySelectorAll('.sponsorblock-segment').forEach(el => el.remove());

        sponsorSegments.forEach(segment => {
            const segmentElement = document.createElement('div');
            segmentElement.className = 'sponsorblock-segment';
            segmentElement.style.position = 'absolute';
            segmentElement.style.height = '100%';
            segmentElement.style.backgroundColor = 'rgba(0, 255, 0, 0.7)';
            segmentElement.style.pointerEvents = 'none';
            segmentElement.style.zIndex = '1';

            const videoDuration = document.querySelector('video').duration;
            const startPercent = (segment.segment[0] / videoDuration) * 100;
            const endPercent = (segment.segment[1] / videoDuration) * 100;
            
            segmentElement.style.left = `${startPercent}%`;
            segmentElement.style.width = `${endPercent - startPercent}%`;

            progressBar.appendChild(segmentElement);
        });
    }

    function checkForSponsorSegment() {
        const video = document.querySelector('video');
        if (!video) return;

        const currentTime = video.currentTime;
        for (let segment of sponsorSegments) {
            if (currentTime >= segment.segment[0] && currentTime < segment.segment[1]) {
                log(`Skipping segment: ${segment.segment[0]} - ${segment.segment[1]}`);
                video.currentTime = segment.segment[1];
                break;
            }
        }
    }

    function getVideoId() {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get('v');
    }

    function init() {
        log('Initializing SponsorBlock script');
        const videoId = getVideoId();
        if (videoId && videoId !== currentVideoId) {
            currentVideoId = videoId;
            fetchSponsorData(videoId);
        }

        const video = document.querySelector('video');
        if (video) {
            log('Adding timeupdate event listener to video');
            video.addEventListener('timeupdate', checkForSponsorSegment);
        }
    }

    // Add CSS for better visibility
    const style = document.createElement('style');
    style.textContent = `
        .sponsorblock-segment {
            opacity: 0.7;
            transition: opacity 0.2s ease-in-out, height 0.2s ease-in-out, top 0.2s ease-in-out;
        }
        .ytp-progress-bar:hover .sponsorblock-segment {
            opacity: 1;
            height: 200% !important;
            top: -50% !important;
        }
    `;
    document.head.appendChild(style);

    // Initialize on various events
    window.addEventListener('yt-navigate-finish', init);
    document.addEventListener('yt-page-data-updated', init);
    window.addEventListener('load', init);
    
    // Reinitialize periodically and on video change
    setInterval(init, 5000);
    document.addEventListener('yt-page-data-updated', () => {
        setTimeout(init, 1000);  // Delay to ensure video element is loaded
    });

    log('SponsorBlock script loaded');
})();
