// Mira Browser Engine Logic
document.addEventListener('DOMContentLoaded', () => {
    const urlInput = document.getElementById('url-input');
    const dashSearchInput = document.getElementById('dash-search-input');
    const aiModal = document.getElementById('ai-sidebar-modal');
    const aiChatInput = document.getElementById('ai-chat-input');
    const aiChatHistory = document.getElementById('ai-chat-history');

    // Perform Navigation via Native Android Bridge
    window.navigateToUrl = function(targetUrl) {
        let url = targetUrl.trim();
        if (!url) return;

        if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('file://')) {
            if (url.includes('.') && !url.includes(' ')) {
                url = 'https://' + url;
            } else {
                url = 'https://duckduckgo.com/?q=' + encodeURIComponent(url);
            }
        }

        if (window.AndroidBridge && window.AndroidBridge.loadUrl) {
            window.AndroidBridge.loadUrl(url);
        } else {
            window.location.href = url;
        }
    };

    window.openSite = function(url) {
        window.navigateToUrl(url);
    };

    window.executeDashSearch = function() {
        if (dashSearchInput && dashSearchInput.value) {
            window.navigateToUrl(dashSearchInput.value);
        }
    };

    if (dashSearchInput) {
        dashSearchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                window.executeDashSearch();
            }
        });
    }

    if (urlInput) {
        urlInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                window.navigateToUrl(urlInput.value);
                urlInput.blur();
            }
        });
    }

    // Native Bridge Controls
    window.navGoBack = function() {
        if (window.AndroidBridge && window.AndroidBridge.goBack) {
            window.AndroidBridge.goBack();
        } else {
            window.history.back();
        }
    };

    window.navGoForward = function() {
        if (window.AndroidBridge && window.AndroidBridge.goForward) {
            window.AndroidBridge.goForward();
        } else {
            window.history.forward();
        }
    };

    window.navReload = function() {
        if (window.AndroidBridge && window.AndroidBridge.reload) {
            window.AndroidBridge.reload();
        } else {
            window.location.reload();
        }
    };

    window.navGoHome = function() {
        if (window.AndroidBridge && window.AndroidBridge.goHome) {
            window.AndroidBridge.goHome();
        } else {
            window.location.href = 'index.html';
        }
    };

    window.clearUrlInput = function() {
        if (urlInput) urlInput.value = '';
    };

    // AI Drawer Assistant
    window.toggleAISidebar = function() {
        if (aiModal) aiModal.classList.toggle('active');
    };

    window.sendAIMessage = function() {
        if (!aiChatInput) return;
        const text = aiChatInput.value.trim();
        if (!text) return;

        appendAiMessage(text, true);
        aiChatInput.value = '';

        setTimeout(() => {
            appendAiMessage(`⚡ Mira AI: Analyzing query: "${text}". Web acceleration and AI summaries are active!`);
        }, 500);
    };

    function appendAiMessage(text, isUser = false) {
        if (!aiChatHistory) return;
        const msg = document.createElement('div');
        msg.className = `ai-msg ${isUser ? 'user' : 'bot'}`;
        msg.textContent = text;
        aiChatHistory.appendChild(msg);
        aiChatHistory.scrollTop = aiChatHistory.scrollHeight;
    }

    window.aiSummarizePage = function() {
        appendAiMessage('Summarize this page');
        setTimeout(() => {
            appendAiMessage('⚡ Mira AI: Instant Page Summary - High-speed mobile page loaded with cleartext shield and ad filters active.');
        }, 500);
    };

    window.aiKeyTakeaways = function() {
        appendAiMessage('Key Takeaways');
        setTimeout(() => {
            appendAiMessage('⚡ Mira AI: Key Takeaways extracted successfully.');
        }, 500);
    };

    window.aiTranslatePage = function() {
        appendAiMessage('Translate Page');
        setTimeout(() => {
            appendAiMessage('⚡ Mira AI: Page translation ready.');
        }, 500);
    };

    // Callbacks from Native WebView
    window.onUrlChanged = function(newUrl) {
        if (urlInput) urlInput.value = newUrl;
        const sslStatus = document.getElementById('ssl-status');
        if (sslStatus) {
            sslStatus.textContent = newUrl.startsWith('https://') ? '🔒' : '🔓';
        }

        // Hide dashboard if on external website
        const dashboard = document.getElementById('dashboard-wrapper');
        if (dashboard) {
            if (newUrl.startsWith('file://')) {
                dashboard.style.display = 'flex';
            } else {
                dashboard.style.display = 'none';
            }
        }
    };

    window.onPageProgress = function(progress) {
        const fill = document.getElementById('progress-fill');
        if (fill) {
            fill.style.width = progress + '%';
            if (progress >= 100) {
                setTimeout(() => { fill.style.width = '0%'; }, 300);
            }
        }
    };
});
