#!/bin/bash

# Settings
ODOO_HOST="$ODOO_HOST"
ODOO_DB_NAME="$ODOO_DB_NAME"
ODOO_MASTER_PASS="$ODOO_MASTER_PASS"
BUCKET_NAME="$BUCKET"

# Path in which to create the backup (will get cleaned later)
BACKUP_PATH="/mnt/data/dump/"

CURRENT_DATE=$(date +"%Y%m%d-%H%M")

# Backup filename
BACKUP_FILENAME="$ODOO_DB_NAME-$CURRENT_DATE.zip"

# Create the backup
curl -o "$BACKUP_PATH""$BACKUP_FILENAME" -S -F 'master_pwd='${ODOO_MASTER_PASS} -F 'name='${ODOO_DB_NAME} -F 'backup_format=zip' $ODOO_HOST/web/database/backup;

# Copy to Google Cloud Storage
echo "Copying $BACKUP_PATH$BACKUP_FILENAME to gs://$BUCKET_NAME/$ODOO_DB_NAME/"
/root/gsutil/gsutil cp "$BACKUP_PATH""$BACKUP_FILENAME" gs://"$BUCKET_NAME"/"$ODOO_DB_NAME"/ 2>&1
echo "Copying finished"
echo "Removing backup data"
rm -rf $BACKUP_PATH*
