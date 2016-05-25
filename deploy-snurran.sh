#!/bin/bash
set -e

if [ $# -ne 1 ] ; then
  echo "Usage: <pro> SPARK_VERSION  (e.g., 1.6.1)"
  exit 1
fi

VERSION=`grep -o -a -m 1 -h -r "version>.*</version" pom.xml | head -1 | sed "s/version//g" | sed "s/>//" | sed "s/<\///g"`

SPARK_VERSION=$1
echo "Livy version is: $VERSION . Spark version is: $SPARK_VERSION"

mvn clean -DskipTests -Dspark.version=$SPARK_VERSION package


scp assembly/target/livy-server-0.3.0-SNAPSHOT.zip glassfish@snurran.sics.se:/var/www/hops/

