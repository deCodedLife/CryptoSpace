#ifndef CRYPTOSPACE_H
#define CRYPTOSPACE_H

#include <QObject>
#include <QImage>

class CryptoSpace : public QObject
{
    Q_OBJECT
public:
    explicit CryptoSpace (QObject *parent = 0);
    Q_INVOKABLE QStringList db_getUserData();
    Q_INVOKABLE void db_register( QString password );
    Q_INVOKABLE bool db_getKey( QString password );
    Q_INVOKABLE QStringList get_files(QString path);
    Q_INVOKABLE int encrypt( QString file );
    Q_INVOKABLE QString getFileContent( QString file );
    Q_INVOKABLE QStringList getAllFiles( QString path );
    Q_INVOKABLE void deleteFile( QString file );
    Q_INVOKABLE QString getTextInfo( QString file );
    Q_INVOKABLE QString getGlobalPath();
private:
    QString iv1 = "X0934K21QL";
    QString iv = "X0934K21QL9P6VJR";
    QString password;
    QByteArray hash;
    QString path = "Storage";
    QByteArray _data;
};

#endif

