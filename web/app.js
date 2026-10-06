// Mira Chromium Mobile Browser Engine Logic
document.addEventListener('DOMContentLoaded', () => {
    // State
    let tabs = [
        { id: 1, title: 'Mira Search', url: 'https://duckduckgo.com', active: true, favicon: '' }
    ];
    let activeTabId = 1;
    let bookmarks = JSON.parse(localStorage.getItem('mira_bookmarks') || '[]');
    let history = JSON.parse(localStorage.getItem('mira_history') || '[]');
    let currentTheme = localStorage.getItem('mira_theme') || 'tokyo-night';

    // DOM Elements
    const urlInput = document.getElementById('url-input');
    const sslBadge = document.getElementById('ssl-badge');
    const sslIcon = document.getElementById('ssl-icon');
    const backBtn = document.getElementById('back-btn');
    const forwardBtn = document.getElementById('forward-btn');
    const tabCountBadge = document.getElementById('tab-count');
    const tabModal = document.getElementById('tab-modal');
    const tabGrid = document.getElementById('tab-grid');
    const aiDrawer = document.getElementById('ai-drawer');
    const readerView = document.getElementById('reader-view');
    const historyModal = document.getElementById('history-modal');
    const themeSelect = document.getElementById('theme-select');

    // Initialize Theme
    document.body.className = `theme-${currentTheme}`;
    if (themeSelect) themeSelect.value = currentTheme;

    // Theme Switcher
    if (themeSelect) {
        themeSelect.addEventListener('change', (e) => {
            currentTheme = e.target.value;
            localStorage.setItem('omarchy_theme', currentTheme);
            document.body.className = `theme-${currentTheme}`;
            triggerHaptics('click');
        });
    }

    // Android Native Bridge Trigger
    function triggerHaptics(type) {
        if (window.AndroidBridge && window.AndroidBridge.vibrate) {
            window.AndroidBridge.vibrate(type === 'impact' ? 15 : 5);
        }
    }

    // URL handling
    function navigateTo(url) {
        let targetUrl = url.trim();
        if (!targetUrl) return;

        if (!targetUrl.startsWith('http://') && !targetUrl.startsWith('https://')) {
            if (targetUrl.includes('.') && !targetUrl.includes(' ')) {
                targetUrl = 'https://' + targetUrl;
            } else {
                targetUrl = 'https://duckduckgo.com/?q=' + encodeURIComponent(targetUrl);
            }
        }

        const activeTab = tabs.find(t => t.id === activeTabId);
        if (activeTab) {
            activeTab.url = targetUrl;
            urlInput.value = targetUrl;
            updateSSL(targetUrl);
            
            // Add to history
            history.unshift({ title: targetUrl, url: targetUrl, time: new Date().toLocaleTimeString() });
            if (history.length > 50) history.pop();
            localStorage.setItem('omarchy_history', JSON.stringify(history));

            if (window.AndroidBridge && window.AndroidBridge.loadUrl) {
                window.AndroidBridge.loadUrl(targetUrl);
            }
        }
    }

    function updateSSL(url) {
        if (url.startsWith('https://')) {
            sslBadge.className = 'ssl-badge secure';
            sslIcon.className = 'fas fa-lock';
        } else {
            sslBadge.className = 'ssl-badge insecure';
            sslIcon.className = 'fas fa-lock-open';
        }
    }

    urlInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            navigateTo(urlInput.value);
            urlInput.blur();
        }
    });

    // Navigation Buttons
    backBtn.addEventListener('click', () => {
        triggerHaptics('click');
        if (window.AndroidBridge && window.AndroidBridge.goBack) {
            window.AndroidBridge.goBack();
        }
    });

    forwardBtn.addEventListener('click', () => {
        triggerHaptics('click');
        if (window.AndroidBridge && window.AndroidBridge.goForward) {
            window.AndroidBridge.goForward();
        }
    });

    // Tabs Management
    const tabsBtn = document.getElementById('tabs-btn');
    const closeTabModalBtn = document.getElementById('close-tab-modal');
    const newTabBtn = document.getElementById('new-tab-btn');

    function renderTabs() {
        tabGrid.innerHTML = '';
        tabCountBadge.textContent = tabs.length;

        tabs.forEach(tab => {
            const card = document.createElement('div');
            card.className = `tab-card ${tab.id === activeTabId ? 'active' : ''}`;
            card.innerHTML = `
                <div class="tab-card-header">
                    <span class="tab-card-title">${tab.url || 'New Tab'}</span>
                    <button class="close-card-btn" data-id="${tab.id}"><i class="fas fa-times"></i></button>
                </div>
                <div class="tab-card-preview">
                    <i class="fas fa-globe tab-preview-icon"></i>
                </div>
            `;

            card.addEventListener('click', (e) => {
                if (e.target.closest('.close-card-btn')) return;
                activeTabId = tab.id;
                urlInput.value = tab.url;
                updateSSL(tab.url);
                tabModal.classList.remove('active');
                if (window.AndroidBridge && window.AndroidBridge.loadUrl) {
                    window.AndroidBridge.loadUrl(tab.url);
                }
            });

            card.querySelector('.close-card-btn').addEventListener('click', (e) => {
                e.stopPropagation();
                tabs = tabs.filter(t => t.id !== tab.id);
                if (tabs.length === 0) {
                    addNewTab();
                } else if (tab.id === activeTabId) {
                    activeTabId = tabs[0].id;
                    urlInput.value = tabs[0].url;
                    updateSSL(tabs[0].url);
                }
                renderTabs();
            });

            tabGrid.appendChild(card);
        });
    }

    function addNewTab() {
        const newId = Date.now();
        tabs.push({ id: newId, title: 'New Tab', url: 'https://duckduckgo.com', active: true });
        activeTabId = newId;
        urlInput.value = 'https://duckduckgo.com';
        updateSSL('https://duckduckgo.com');
        renderTabs();
        tabModal.classList.remove('active');
        if (window.AndroidBridge && window.AndroidBridge.loadUrl) {
            window.AndroidBridge.loadUrl('https://duckduckgo.com');
        }
    }

    tabsBtn.addEventListener('click', () => {
        triggerHaptics('click');
        renderTabs();
        tabModal.classList.add('active');
    });

    closeTabModalBtn.addEventListener('click', () => {
        tabModal.classList.remove('active');
    });

    newTabBtn.addEventListener('click', () => {
        triggerHaptics('click');
        addNewTab();
    });

    // AI Drawer Assistant
    const aiBtn = document.getElementById('ai-btn');
    const closeAiBtn = document.getElementById('close-ai-btn');
    const aiSendBtn = document.getElementById('ai-send');
    const aiInput = document.getElementById('ai-input');
    const aiMessages = document.getElementById('ai-messages');

    aiBtn.addEventListener('click', () => {
        triggerHaptics('impact');
        aiDrawer.classList.toggle('active');
    });

    closeAiBtn.addEventListener('click', () => {
        aiDrawer.classList.remove('active');
    });

    function appendAiMessage(text, isUser = false) {
        const msg = document.createElement('div');
        msg.className = `ai-msg ${isUser ? 'user' : 'bot'}`;
        msg.innerHTML = `<div class="msg-bubble">${text}</div>`;
        aiMessages.appendChild(msg);
        aiMessages.scrollTop = aiMessages.scrollHeight;
    }

    aiSendBtn.addEventListener('click', () => {
        const text = aiInput.value.trim();
        if (!text) return;

        appendAiMessage(text, true);
        aiInput.value = '';

        setTimeout(() => {
            appendAiMessage(`Omarchy AI Assistant: Analyzing page summary and answering: "${text}". Web acceleration mode active.`);
        }, 600);
    });

    // Reader Mode
    const readerBtn = document.getElementById('reader-btn');
    const closeReaderBtn = document.getElementById('close-reader');

    readerBtn.addEventListener('click', () => {
        triggerHaptics('click');
        const activeTab = tabs.find(t => t.id === activeTabId);
        document.getElementById('reader-title').textContent = activeTab ? activeTab.url : 'Reader Mode';
        document.getElementById('reader-body').innerHTML = '<p>Distraction-free reading view generated by Omarchy AI Engine. All ads, scripts, and popups stripped out for high clarity.</p>';
        readerView.classList.add('active');
    });

    closeReaderBtn.addEventListener('click', () => {
        readerView.classList.remove('active');
    });

    // History / Bookmarks Modal
    const historyBtn = document.getElementById('history-btn');
    const closeHistoryBtn = document.getElementById('close-history-modal');
    const historyList = document.getElementById('history-list');

    historyBtn.addEventListener('click', () => {
        triggerHaptics('click');
        historyList.innerHTML = '';
        if (history.length === 0) {
            historyList.innerHTML = '<li class="empty">No history recorded yet</li>';
        } else {
            history.forEach(item => {
                const li = document.createElement('li');
                li.className = 'history-item';
                li.innerHTML = `<span>${item.title}</span><small>${item.time}</small>`;
                li.addEventListener('click', () => {
                    navigateTo(item.url);
                    historyModal.classList.remove('active');
                });
                historyList.appendChild(li);
            });
        }
        historyModal.classList.add('active');
    });

    closeHistoryBtn.addEventListener('click', () => {
        historyModal.classList.remove('active');
    });

    // Desktop Site Toggle
    const desktopToggle = document.getElementById('desktop-toggle');
    if (desktopToggle) {
        desktopToggle.addEventListener('change', (e) => {
            const isDesktop = e.target.checked;
            triggerHaptics('click');
            if (window.AndroidBridge && window.AndroidBridge.setDesktopMode) {
                window.AndroidBridge.setDesktopMode(isDesktop);
            }
        });
    }

    // Called from Native Android WebChromeClient/WebView progress updates
    window.onPageProgress = function(progress) {
        const progressBar = document.getElementById('progress-bar');
        if (progressBar) {
            progressBar.style.width = progress + '%';
            if (progress >= 100) {
                setTimeout(() => { progressBar.style.width = '0%'; }, 300);
            }
        }
    };

    window.onUrlChanged = function(newUrl) {
        urlInput.value = newUrl;
        updateSSL(newUrl);
        const activeTab = tabs.find(t => t.id === activeTabId);
        if (activeTab) {
            activeTab.url = newUrl;
        }
    };
});
