#!/bin/bash
#cpanel-accounts-backup-Dilip-AWT.sh
#Last Modified 2016-08-016
#Modified by dilip

DATE=`date '+%Y-%m-%d_%H-%M'`
BAKPATH="/backup/cpanel-lakuri-c1-users"
BACKUPDIR="${BAKPATH}/$DATE"
mkdir -p $BACKUPDIR
find ${BAKPATH}/* -type d -ctime +30 -exec rm -rf {} \;

LOGFILE="${BAKPATH}/cpanel-accounts-backup-Dilip-AWT.log"
echo"" >> $LOGFILE

# accounts NOT to backup
EXCEPTIONS="nobody;system;"

#log funtion
function f_log()
{
  STAMP=`date '+%Y-%m-%d %H:%M:%S'`
  echo "${STAMP} ${1}"
  echo "${STAMP} ${1}" >> ${LOGFILE}
}

# Loop to Backup the user account created by Resesllers
f_log "------------------------------------------------------------"
f_log "------------ Backing up Cpanel accounts started ------------"
f_log "------------------------------------------------------------"

#Loop to backup the user account created by root admin.
  f_log""
  f_log "-- Getting list of user accounts "

UCOUNT=0
for ACCT in `(ls -1A /var/cpanel/users/)`
  do
    # Check to see if current RESSELLER should be skipped.
    if echo "${EXCEPTIONS}" | grep -q ${ACCT}
    then
    # Exception found, skip this account.
    echo "" > /dev/null
    else
      # Backup user account.
      UCOUNT=$((UCOUNT+1))
      TCOUNT=$((TCOUNT+1))
      f_log "--- Backing up user ${ACCT}"
      /usr/local/cpanel/scripts/pkgacct ${ACCT} ${BACKUPDIR}/
      #echo "${ACCT} - $UCOUNT"
      RETURNVALUE=$?
     if [ ! ${RETURNVALUE} -eq 0 ]; then
      # Something went wrong.
      f_log "---- Error on ${ACCT}, exit code ${RETURNVALUE}"
      ERRORFLAG=$((ERRORFLAG+1))
     fi
   fi
  done
chmod -r 755 ${BACKUPDIR}/*.tar.gz
f_log "------------------------------------------------------"
f_log "-- ${TCOUNT} accounts processed ALL TOGETHER, Backup dir: $BACKUPDIR/"
f_log "------------------------------------------------------"

