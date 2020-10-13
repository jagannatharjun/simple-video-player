#ifndef SYSTEMLOCKMANAGER_H
#define SYSTEMLOCKMANAGER_H

#include <QObject>

class SystemLockManager : public QObject
{
    Q_OBJECT
public:
    explicit SystemLockManager(QObject *parent = nullptr);

    Q_INVOKABLE void preventSystemLock(bool prevent);

};

#endif // SYSTEMLOCKMANAGER_H
