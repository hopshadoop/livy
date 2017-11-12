#!/bin/bash
set -e

if [ $# -lt 1 ] ; then
  echo "Usage: $0 SPARK_VERSION [test]  (e.g., 2.2)"
  exit 1
fi

VERSION=`grep -o -a -m 1 -h -r "version>.*</version" pom.xml | head -1 | sed "s/version//g" | sed "s/>//" | sed "s/<\///g"`

#git checkout master
#git fetch upstream
#git merge upstream/master

SPARK_VERSION=$1
echo "Livy version is: $VERSION . Spark version is: $SPARK_VERSION"

mvn clean -DskipTests -Pspark-$SPARK_VERSION package

if [ $# -gt 1 ] ; then
  if [ "$2" == "test" ] ; then
    scp assembly/target/livy-server-${VERSION}.zip glassfish@snurran.sics.se:/var/www/hops/test
  else
    echo "Error. The only valid 2nd parameter is 'test'"
    exit 2
  fi
else 
  scp assembly/target/livy-${VERSION}-bin.zip glassfish@snurran.sics.se:/var/www/hops/
fi

