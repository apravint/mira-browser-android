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

public class MainActivity extends Activity {

    private WebView webView;
    private static final String DESKTOP_USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36";
    private static final String MOBILE_USER_AGENT = "Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED
        );

        webView = new WebView(this);
        setContentView(webView);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setBuiltInZoomControls(true);
        settings.setDisplayZoomControls(false);
        settings.setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
        settings.setUserAgentString(MOBILE_USER_AGENT);

        webView.addJavascriptInterface(new BrowserBridge(), "AndroidBridge");
        webView.setWebViewClient(new WebViewClient());
        webView.setWebChromeClient(new WebChromeClient());

        webView.setDownloadListener(new DownloadListener() {
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

        webView.loadUrl("file:///android_asset/web/index.html");
    }

    @Override
    public void onBackPressed() {
        if (webView != null) {
            webView.evaluateJavascript("if(window.onBackPressed) window.onBackPressed(); else history.back();", null);
        } else {
            super.onBackPressed();
        }
    }

    public class BrowserBridge {

        @JavascriptInterface
        public void setDesktopMode(boolean desktop) {
            if (webView != null) {
                webView.post(new Runnable() {
                    @Override
                    public void run() {
                        if (desktop) {
                            webView.getSettings().setUserAgentString(DESKTOP_USER_AGENT);
                        } else {
                            webView.getSettings().setUserAgentString(MOBILE_USER_AGENT);
                        }
                    }
                });
            }
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
                if (webView != null) {
                    webView.post(new Runnable() {
                        @Override
                        public void run() {
                            webView.performHapticFeedback(android.view.HapticFeedbackConstants.KEYBOARD_TAP);
                        }
                    });
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
