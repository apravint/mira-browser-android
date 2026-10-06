package com.apravint.mirabrowser;

import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.JavascriptInterface;
import android.webkit.DownloadListener;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.view.Window;
import android.view.WindowManager;
import android.view.View;
import android.widget.FrameLayout;

public class MainActivity extends Activity {

    private WebView mainWebView;
    private static final String DESKTOP_USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36";
    private static final String MOBILE_USER_AGENT = "Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36";
    private String homeUrl = "file:///android_asset/web/index.html";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED
        );

        FrameLayout layout = new FrameLayout(this);
        mainWebView = new WebView(this);
        layout.addView(mainWebView);
        setContentView(layout);

        WebSettings settings = mainWebView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);
        settings.setBuiltInZoomControls(true);
        settings.setDisplayZoomControls(false);
        settings.setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
        settings.setUserAgentString(MOBILE_USER_AGENT);

        mainWebView.addJavascriptInterface(new NativeBridge(), "AndroidBridge");
        
        mainWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url.startsWith("http://") || url.startsWith("https://") || url.startsWith("file://")) {
                    view.loadUrl(url);
                    return true;
                }
                return false;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                view.evaluateJavascript("if(window.onUrlChanged) window.onUrlChanged('" + url + "');", null);
            }
        });

        mainWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
                view.evaluateJavascript("if(window.onPageProgress) window.onPageProgress(" + newProgress + ");", null);
            }
        });

        mainWebView.setDownloadListener(new DownloadListener() {
            @Override
            public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {
                try {
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setData(Uri.parse(url));
                    startActivity(intent);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        mainWebView.loadUrl(homeUrl);
    }

    @Override
    public void onBackPressed() {
        if (mainWebView != null && mainWebView.canGoBack()) {
            mainWebView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    public class NativeBridge {

        @JavascriptInterface
        public void loadUrl(final String url) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mainWebView != null) {
                        mainWebView.loadUrl(url);
                    }
                }
            });
        }

        @JavascriptInterface
        public void goBack() {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mainWebView != null && mainWebView.canGoBack()) {
                        mainWebView.goBack();
                    }
                }
            });
        }

        @JavascriptInterface
        public void goForward() {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mainWebView != null && mainWebView.canGoForward()) {
                        mainWebView.goForward();
                    }
                }
            });
        }

        @JavascriptInterface
        public void goHome() {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mainWebView != null) {
                        mainWebView.loadUrl(homeUrl);
                    }
                }
            });
        }

        @JavascriptInterface
        public void reload() {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mainWebView != null) {
                        mainWebView.reload();
                    }
                }
            });
        }

        @JavascriptInterface
        public void setDesktopMode(final boolean desktop) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (mainWebView != null) {
                        mainWebView.getSettings().setUserAgentString(desktop ? DESKTOP_USER_AGENT : MOBILE_USER_AGENT);
                        mainWebView.reload();
                    }
                }
            });
        }

        @JavascriptInterface
        public void shareUrl(String url, String title) {
            try {
                Intent intent = new Intent(Intent.ACTION_SEND);
                intent.setType("text/plain");
                intent.putExtra(Intent.EXTRA_SUBJECT, title);
                intent.putExtra(Intent.EXTRA_TEXT, url);
                startActivity(Intent.createChooser(intent, "Share Link via"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @JavascriptInterface
        public void vibrate(int duration) {
            try {
                if (mainWebView != null) {
                    mainWebView.post(new Runnable() {
                        @Override
                        public void run() {
                            mainWebView.performHapticFeedback(android.view.HapticFeedbackConstants.KEYBOARD_TAP);
                        }
                    });
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
