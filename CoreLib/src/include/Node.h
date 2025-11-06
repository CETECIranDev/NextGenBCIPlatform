#pragma once

#include <QObject>
#include <QUuid>
#include <QString>
#include <QPointF>
#include <QVariantMap>

class Node : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUuid uuid READ uuid CONSTANT)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(QPointF position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(QVariantMap parameters READ parameters WRITE setParameters NOTIFY parametersChanged)

public:
    explicit Node(QObject *parent = nullptr);
    
    QUuid uuid() const { return m_uuid; }
    QString name() const { return m_name; }
    QString category() const { return m_category; }
    QPointF position() const { return m_position; }
    QVariantMap parameters() const { return m_parameters; }

public slots:
    void setName(const QString& name);
    void setCategory(const QString& category);
    void setPosition(const QPointF& position);
    void setParameters(const QVariantMap& parameters);

signals:
    void nameChanged();
    void categoryChanged();
    void positionChanged();
    void parametersChanged();

private:
    QUuid m_uuid;
    QString m_name;
    QString m_category;
    QPointF m_position;
    QVariantMap m_parameters;
};