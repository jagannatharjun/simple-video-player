#include "systemlockmanager.h"

#ifdef Q_OS_WIN

#include <Windows.h>

void preventSystemLockImpl(bool prevent)
{
    if (prevent) {
        SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
    } else {
        SetThreadExecutionState(ES_CONTINUOUS);
    }
}

#elif defined(Q_OS_LINUX)

#include <X11/Xlib.h>

void preventSystemLockImpl(bool prevent)
{
    Display *dpy = XOpenDisplay(NULL);
    XResetScreenSaver(dpy);
    XCloseDisplay(dpy);
}

#else

// MACOS and other systems
#include <QDebug>

void preventSystemLockImpl(bool /*prevent*/)
{
    qWarning("preventSystemLockImpl not implemented");
}

#endif

SystemLockManager::SystemLockManager(QObject *parent)
    : QObject{parent}
{

}

void SystemLockManager::preventSystemLock(bool prevent)
{
    preventSystemLockImpl(prevent);
}
