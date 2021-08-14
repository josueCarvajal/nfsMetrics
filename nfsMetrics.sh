#!/bin/bash
#nfs mount required
if [ $# -ne 1 ] 
then
	echo "Usage: nfsMetrics.sh /opt/mnt/nfs_mount_name"
	exit 1
fi
NFS_MOUNT=$1
#a folder called nfsMetrics is needed
TEST_FOLDER=$NFS_MOUNT/nfsMetrics
#final file that wil contain the results
MIDDLE_FILE=/tmp/metrics.middle
#tmp file that will handle the raw values
TMP_FILE=/tmp/metrics.tmp
OUTPUT_FILE=/tmp/metrics.report
#if folder does not exists, create it
if [ ! -d $TEST_FOLDER ]; then
        mkdir $TEST_FOLDER;
fi
#Write test
echo "***" >> $TMP_FILE
echo $(date) >> $TMP_FILE
echo "Write" >> $TMP_FILE
(time for i in {0..1000}
do
    echo 'test' > "$TEST_FOLDER/test${i}.txt"
done) >> $TMP_FILE 2>&1
#Read Test
echo "***" >> $TMP_FILE
echo $(date) >> $TMP_FILE
echo "Read" >> $TMP_FILE
(time for i in {0..1000}
do
    cat "$TEST_FOLDER/test${i}.txt" > /dev/null
done) >> $TMP_FILE 2>&1
tr '\n' ',' <$TMP_FILE >> $MIDDLE_FILE 2>&1
#lets clean the final file
sed -i 's/real/ /g' "$MIDDLE_FILE"
sed -i 's/user/ /g' "$MIDDLE_FILE"
sed -i 's/sys/ /g' "$MIDDLE_FILE"
sed -i 's/,,/,/g' "$MIDDLE_FILE"
tr "***" "\n" <$MIDDLE_FILE >> $OUTPUT_FILE 2>&1

rm $MIDDLE_FILE
rm $TMP_FILE
#clean everything for the next execution
sudo rm -r $TEST_FOLDER