// This library writed by コード化されたライブ

#include "cryptospace.h"
#include "qaesencryption.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QSql>
#include <QDir>
#include <QFile>
#include <QImage>
#include <QDebug>
#include <QDirIterator>
#include <QSqlDatabase>
#include <QCryptographicHash>
#include <QSqlError>
#include <QSqlQuery>

CryptoSpace::CryptoSpace(QObject *parent): QObject(parent)
{
    QSqlDatabase base = QSqlDatabase::addDatabase("QSQLITE");
    base.setDatabaseName("data.bin");
    bool exists = false;
    if ( QFile("data.bin").exists() ) exists = true;
    if ( !base.open() ) qDebug() << base.lastError().text();
    else {
        QSqlQuery query;
        if ( !exists ) query.exec("create table user_data ("
                                  "password text not null,"
                                  "hash     text not null );");
    }

    base.close();
}

QStringList CryptoSpace::db_getUserData() {
    QSqlDatabase base = QSqlDatabase::addDatabase("QSQLITE");
    base.setDatabaseName("data.bin");
    QStringList data;
    if ( !base.open() ) qDebug() << base.lastError().text();
    else {
        QSqlQuery query;
        query.exec("SELECT * FROM user_data");
        query.next();
        QString password = query.value(0).toString();
        QString hash     = query.value(1).toString();
        data.append(password);
        data.append(hash);
    }
    if ( !QDir("Storage").exists() ) QDir().mkdir("Storage");
    base.close();
    return data;
}

void CryptoSpace::db_register(QString password) {
    QCryptographicHash sha512 (QCryptographicHash::Sha512);
    QAESEncryption encryption(QAESEncryption::AES_256, QAESEncryption::CBC);
    QList<QString> chars = {"A","a","B","b","C","c","D","d","E","e","F","f","G","g",
                    "H","h","I","i","J","j","K","k","L","l","M","m","N","n",
                    "O","o","P","p","Q","q","R","r","S","s","T","t","U","u",
                    "V","v","W","w","X","x","Y","y","Z","z","!","@","$","%",
                    "*","1","2","3","4","5","6","7","8","9","0",".","-","/"};
    QSqlDatabase base = QSqlDatabase::addDatabase("QSQLITE");
    base.setDatabaseName("data.bin");
    QString newPassw;
    for (int i = 0; i < 32; i++) {
        int num = rand()%9+1;
        if(rand()%2+1 == 1) newPassw = newPassw + QString::number(num);
        else newPassw = newPassw + chars[rand()%(sizeof(chars)/sizeof(char))];
    }
    QByteArray hashKey = QCryptographicHash::hash(password.toLatin1(),  QCryptographicHash::Sha256);
    QByteArray hashIV  = QCryptographicHash::hash(iv.toLatin1(),        QCryptographicHash::Md5);
    QByteArray encodeText = encryption.encode(newPassw.toLatin1(), hashKey, hashIV);
    sha512.addData(password.toLatin1());
    if ( !base.open() ) qDebug() << base.lastError().text();
    else {
        QSqlQuery query;
        QByteArray result = sha512.result();
        query.exec("INSERT INTO user_data (password, hash) VALUES (\""+result.toHex()+"\", \""+encodeText.toHex()+"\") ");
    }
    base.close();
    hash =  QByteArray::fromStdString(newPassw.toStdString());
}

bool CryptoSpace::db_getKey(QString password){
    QCryptographicHash sha512 (QCryptographicHash::Sha512);
    QAESEncryption encryption(QAESEncryption::AES_256, QAESEncryption::CBC);
    QSqlDatabase base = QSqlDatabase::addDatabase("QSQLITE");
    base.setDatabaseName("data.bin");
    if ( !base.open() ) qDebug() << base.lastError().text();
    else {
        QSqlQuery query;
        query.exec("SELECT * FROM user_data");
        query.next();
        QString passw = query.value(0).toString();
        QString encod = query.value(1).toString();
        sha512.addData(password.toLatin1());
        if (sha512.result().toHex() == passw)
        {
            QByteArray hashKey = QCryptographicHash::hash(password.toLatin1(), QCryptographicHash::Sha256);
            QByteArray hashIV  = QCryptographicHash::hash(iv.toLatin1(),     QCryptographicHash::Md5);
            QByteArray decodeText = encryption.decode(QByteArray::fromHex(encod.toLatin1()), hashKey, hashIV);
            hash = decodeText;
            return true;
        } else return false;
    }
    base.close();
    return true;
}

QStringList CryptoSpace::get_files(QString path){
    QStringList data;
    QDirIterator iter(path, QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot );
    while ( iter.hasNext() ) data << iter.next();
    return data;
}

QStringList CryptoSpace::getAllFiles(QString path) {
    QStringList data;
    QDirIterator iter(path, QDir::Files | QDir::NoDotAndDotDot, QDirIterator::Subdirectories );
    while ( iter.hasNext() ) data << iter.next();
    return data;
}

int CryptoSpace::encrypt(QString file) {
    QCryptographicHash sha512 (QCryptographicHash::Sha512);
    QAESEncryption encryption(QAESEncryption::AES_256, QAESEncryption::CBC);
    QString paths = QDir::currentPath() + "/";
    QString npath;
    QStringList arr = file.split("/");
    QString fname = arr[arr.length() - 1];
    for ( int i = 0; i < arr.length(); i++ ) { if ( i != arr.length() - 1 ) npath = npath + arr[i] + "/"; }
    QList<QString> tmp = fname.split(".");
    if (tmp[1] == "crp") {
        QFile files(paths + file);
        if (!files.isOpen()) files.open(QIODevice::ReadOnly);
        QByteArray encoded = files.readAll();
        QByteArray hashKey = QCryptographicHash::hash(hash, QCryptographicHash::Sha256);
        QByteArray hashIV  = QCryptographicHash::hash(iv.toLatin1(),   QCryptographicHash::Md5);
        QByteArray decodeText = encryption.decode(encoded, hashKey, hashIV);
        QByteArray filename = QByteArray::fromBase64(tmp[0].toLatin1());
        QByteArray s_name = encryption.decode(QByteArray::fromHex(filename), hashKey, hashIV );
        s_name = QByteArray::fromBase64(s_name);
        QFile nfile(paths + npath + QString::fromUtf8(s_name) );
        QList<QByteArray> nArr = decodeText.split('\x80\x80\x00\x00\x00\x00');
        if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        while (! nfile.isOpen() )
            if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        if (nfile.isOpen() )
        {
            if ( nArr.length() == 2 ) nfile.write(nArr[0]);
            else nfile.write( decodeText );
            files.remove();
        } else return 1;
        nfile.close();
        files.close();
        return 0;
    } else {
        QFile files(paths + file);
        if (!files.isOpen()) files.open(QIODevice::ReadOnly);
        QByteArray decoded = files.readAll();
        QByteArray hashKey = QCryptographicHash::hash(hash, QCryptographicHash::Sha256);
        QByteArray hashIV  = QCryptographicHash::hash(iv.toLatin1(),   QCryptographicHash::Md5);
        QByteArray encodeText = encryption.encode(decoded, hashKey, hashIV);
        QStringList fileName = file.split("/");
        QByteArray name = fname.toUtf8().toBase64();
        QByteArray encodeFile = encryption.encode( name, hashKey, hashIV );
        QFile nfile(paths + npath + "/" + encodeFile.toHex().toBase64() + ".crp");
        if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        while (! nfile.isOpen() )
            if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        if (nfile.isOpen() && encodeText.length() > 1)
        {
            nfile.write(encodeText);
            files.remove();
        } else return 1;
        nfile.close();
        files.close();
        return 0;
    }
}

QString CryptoSpace::getFileContent(QString file) {
    QStringList arr = file.split("/");
    QStringList ext = arr[ arr.length() - 1 ].split(".");
    QString paths = QDir::currentPath() + "/";
    if ( ext[1] == "crp" ) {
        QByteArray data;
        QCryptographicHash sha512 (QCryptographicHash::Sha512);
        QAESEncryption encryption(QAESEncryption::AES_256, QAESEncryption::CBC);
        QString npath;
        QStringList arr = file.split("/");
        QString fname = arr[arr.length() - 1];
        for ( int i = 0; i < arr.length(); i++ ) { if ( i != arr.length() - 1 ) npath = npath + arr[i] + "/"; }
        QFile files(paths + file);
        if (!files.isOpen()) files.open(QIODevice::ReadOnly);
        QByteArray encoded = files.readAll();
        QByteArray hashKey = QCryptographicHash::hash(hash, QCryptographicHash::Sha256);
        QByteArray hashIV  = QCryptographicHash::hash(iv.toLatin1(),   QCryptographicHash::Md5);
        QByteArray decodeText = encryption.decode(encoded, hashKey, hashIV);
        QList<QByteArray> nArr = decodeText.split('\x80\x80\x00\x00\x00\x00');
        files.close();
        if ( nArr.length() == 2 ) data = nArr[0].toBase64();
        else data = decodeText.toBase64();

        QByteArray filename = QByteArray::fromBase64(ext[0].toLatin1());
        QByteArray s_name = encryption.decode(QByteArray::fromHex(filename), hashKey, hashIV );
        s_name = QByteArray::fromBase64(s_name);
        QString fileName = paths + QString::fromUtf8(s_name);
        qDebug()<< "view: " +fileName;
        QFile nfile( fileName );
        if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        while (! nfile.isOpen() )
            if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        if (nfile.isOpen() )
        {
            if ( nArr.length() == 2 ) nfile.write(nArr[0]);
            else nfile.write( decodeText );
        }

        return fileName;
    } else {
        QFile files(paths + file);
        if (!files.isOpen()) files.open(QIODevice::ReadOnly);
        QByteArray data = files.readAll();
        QString fileName = paths + arr[ arr.length() - 1 ];
        QFile nfile(fileName);
        if (!nfile.isOpen()) nfile.open(QIODevice::WriteOnly);
        nfile.write(data);
        files.close();
        nfile.close();
        return fileName;
    }
}

void CryptoSpace::deleteFile(QString file){ QFile( file ).remove(); qDebug() << "File: " + file + " deleted"; }

QString CryptoSpace::getTextInfo(QString file) {
    QFile fileObj(file);
    if (!fileObj.isOpen()) fileObj.open(QIODevice::ReadOnly);
    QString data = fileObj.readAll();
    return data;
}

QString CryptoSpace::getGlobalPath(){ return QDir::currentPath() + "/"; }
