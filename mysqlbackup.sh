#! /bin/bash
# Written by Vasanth.T.M
# Copyright  2021


CKUPDATE=$(date +%d-%m-%Y)
BACKUPDIR=/mysqlbackup
DATABASES=$(mysql -u root -h localhost -pmysql -Bse 'show databases')


delete_old ()
{
echo Deleting old backup of backup of "$name"
name="$1"
find "$BACKUPDIR" -name "$name-*.sql.bz2" | sort | head -n -2 | xargs --no-run-if-empty rm -f
}

back ()
{
for GH in $DATABASES; do
echo "Creating mysql backup of $GH"
mysqldump -u root -pmysql $GH | bzip2 --compress --stdout > $BACKUPDIR/$GH-$CKUPDATE.sql.bz2
name=`basename $GH`
delete_old "$name"
done
}
back
