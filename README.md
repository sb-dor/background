# 🔍 Understanding Foreground vs Background Services in Android

When building Flutter apps that require persistent background functionality (like location tracking or music playback), it's essential to understand the difference between **app state** and **Android service types**.

---

## 📱 App States

| State                | Description                                                                  |
|----------------------|------------------------------------------------------------------------------|
| **Foreground (App)** | The app is **open and visible** on the screen.                              |
| **Background (App)** | The app is **minimized or in the background**, but still running.           |
| **Terminated (App)** | The app is **manually closed** or killed by the system (e.g., swipe to kill).|

---

## ⚙️ Service Types

| Service Type           | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| **Background Service** | Runs silently in the background. **Can be killed** by the system anytime.   |
| **Foreground Service** | Runs in the background but **must show a persistent notification**.         <br>It gets **higher priority** and is **less likely to be killed** by the system. |

---

## 🚨 Important Distinction

> A **foreground service** is **not** the same as your app being in the foreground.

A **foreground service** means that your app **can continue to run code** in the background **even when it is closed or killed**, **as long as a visible notification is shown**.

---

## ✅ When to Use Foreground Service

Foreground services are required for:

- Real-time **location tracking** (e.g. for couriers or taxi apps)
- **Media playback**
- **Download/upload** tasks
- **Long-running background tasks** that must not be interrupted

---

## 📌 Example Use Case

If you're building an app where a courier needs to constantly send their location to a server — even when the app is minimized or closed — you **must use a foreground service**.

Without a foreground service, Android may suspend or kill your app, and background code execution will stop.

---

## 🛑 iOS Limitation

> iOS does **not** support long-running background services like Android.

On iOS, background execution is limited to short bursts (usually 15–30 seconds), triggered by the OS using Background Fetch, and can’t happen more often than every 15 minutes.