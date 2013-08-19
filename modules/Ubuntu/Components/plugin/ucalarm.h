/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Zsombor Egri <zsombor.egri@canonical.com>
 */

#ifndef UCALARM_H
#define UCALARM_H

#include <QtCore/QObject>
#include <QtCore/QDateTime>
#include <QtCore/QUrl>

class UCAlarmPrivate;
class UCAlarm : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(AlarmType type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(DaysOfWeek daysOfWeek READ daysOfWeek WRITE setDaysOfWeek NOTIFY daysOfWeekChanged)
    Q_PROPERTY(QUrl sound READ sound WRITE setSound NOTIFY soundChanged)
    Q_PROPERTY(int error READ error NOTIFY errorChanged)

    Q_ENUMS(Error AlarmType DayOfWeek)
    Q_FLAGS(DaysOfWeek)
public: // enums
    enum Error {
        NoError = 0,
        InvalidDate = 1,
        EarlyDate = 2,
        NoDaysOfWeek = 3,
        OneTimeOnMoreDays = 4,
        InvalidEvent = 5,
        AdaptationError = 100
    };

    enum AlarmType {
        OneTime,
        Repeating // more to be added
    };

    enum DayOfWeek {
        Monday      = 0x01,
        Tuesday     = 0x02,
        Wednesday   = 0x04,
        Thursday    = 0x08,
        Friday      = 0x10,
        Saturday    = 0x20,
        Sunday      = 0x40,
        Daily = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday,
        AutoDetect  = 0x80
    };
    Q_DECLARE_FLAGS(DaysOfWeek, DayOfWeek)

public:
    explicit UCAlarm(QObject *parent = 0);
    UCAlarm(const QDateTime &dt, const QString &message = QString(), QObject *parent = 0);
    UCAlarm(const QDateTime &dt, DaysOfWeek days = AutoDetect, const QString &message = QString(), QObject *parent = 0);
    ~UCAlarm();

public: // getter/setter
    bool enabled() const;
    void setEnabled(bool enabled);
    QDateTime date() const;
    void setDate(const QDateTime &date);
    QString message() const;
    void setMessage(const QString &message);
    AlarmType type() const;
    void setType(AlarmType type);
    DaysOfWeek daysOfWeek() const;
    void setDaysOfWeek(DaysOfWeek days);
    QUrl sound() const;
    void setSound(const QUrl &sound);

    int error() const;

Q_SIGNALS:
    void enabledChanged();
    void messageChanged();
    void dateChanged();
    void typeChanged();
    void daysOfWeekChanged();
    void soundChanged();
    void errorChanged();

public Q_SLOTS:
    void save();
    void cancel();
    void reset();

private:
    Q_DISABLE_COPY(UCAlarm)
    Q_DECLARE_PRIVATE(UCAlarm)
    QScopedPointer<UCAlarmPrivate> d_ptr;
};

Q_DECLARE_OPERATORS_FOR_FLAGS(UCAlarm::DaysOfWeek)

#endif // UUALARM_H

