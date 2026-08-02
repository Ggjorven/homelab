# Backing up data with rsync

This file contains the steps for backing up data using **rsync**, made mainly for me since I kept regoogling it every time.  
This allows us to create an incremental, space-efficient backup of for example a NAS to a backup drive.

## Steps

1. Check available disk space on the destination before starting (see [Utils](#utils)):
    ```
    df -h /mnt/nas_backup/
    ```

2. Run the backup using **rsync** with the following command:
    ```
    rsync -ahPHS --partial --stats --exclude='.Trash-*' /export/nas /mnt/nas_backup/
    ```
    Flag breakdown:
    | Flag | Description |
    |---|---|
    | `-a` | Archive mode, preserves permissions, timestamps, symlinks, owner, group, and device files |
    | `-h` | Human-readable file sizes in output (K, M, G) |
    | `-P` | Shows per-file progress and keeps partial transfers on interruption |
    | `-H` | Preserves hard links instead of duplicating their data |
    | `-S` | Handles sparse files efficiently, saving disk space |
    | `--partial` | Explicitly retains incomplete files so the sync can be resumed |
    | `--stats` | Prints a transfer summary when the sync completes |
    | `--exclude='.Trash-*'` | Excludes trash directories from the backup |

3. If the transfer is interrupted, simply re-run the **same command**. rsync will pick up where it left off thanks to `--partial` and `-P`.

4. After the backup completes, verify the destination size looks correct:
    ```
    df -h /mnt/nas_backup/
    ```

5. Optionally do a **dry-run** first to preview what would be transferred without making any changes:
    ```
    rsync -ahPHS --partial --stats --exclude='.Trash-*' --dry-run /export/nas/ /mnt/nas_backup/
    ```

6. When your backup is done you can use the same command in reverse (and with the `--exclude`):
    ```
    rsync -ahPHS --partial --stats --dry-run /mnt/nas_backup/ /export/nas/
    ```

## Utils

### Checking disk usage with `df -h`

`df` (**d**isk **f**ree) reports the amount of disk space used and available on mounted filesystems.  
The `-h` flag makes the output **human-readable** (sizes shown in K, M, G, T).

**Check a specific folder's filesystem:**
```
df -h /folder/
```

example:
```
df -h /mnt/nas_backup/
```

example output:
```
Filesystem      Size  Used Avail Use%  Mounted on
/dev/sdb1       7.3T  4.1T  3.2T  57%  /mnt/nas_backup
```
