#pragma once

#include <QObject>
#include <QString>

class IPlugin : public QObject
{
    Q_OBJECT

public:
    virtual ~IPlugin() = default;

    virtual QString pluginId() const = 0;
    virtual QString pluginName() const = 0;
    virtual QString pluginVersion() const = 0;
    virtual QString pluginCategory() const = 0;

    virtual bool initialize() = 0;
    virtual void shutdown() = 0;
};

Q_DECLARE_INTERFACE(IPlugin, "com.bcistudio.plugin/1.0")