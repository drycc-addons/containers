import sys
import subprocess
import uvicorn
import contextlib
from fastapi import FastAPI
from fastapi.responses import StreamingResponse

app = FastAPI()

@app.get("/pg_backup")
async def pg_backup():
    shell_bash =  """
          echo 'backup begin.: ' `hostname` `date`
          if [ -f /opt/drycc/postgresql/backup/backup.env ]; then
            source /opt/drycc/postgresql/backup/backup.env
            if [ $(echo $USE_WALG | tr '[:upper:]' '[:lower:]') == 'true' ]; then
              wal-g backup-push $PGDATA
              wal-g delete retain FULL $BACKUP_NUM_TO_RETAIN --confirm
              echo 'backup done.: ' `hostname` `date`
            fi
          fi
        """
    process = subprocess.Popen(
        shell_bash,
        stdout=subprocess.PIPE,
        stdin=subprocess.PIPE,
        shell=True
    )
    return StreamingResponse(process.stdout, media_type="text/plain")


if __name__ == "__main__":
    uvicorn.run(app, host=sys.argv[1], port=int(sys.argv[2]))
##
# pip3 install uvicorn
# pip3 install fastapi
# python3 backup.py  0.0.0.0 9000
# curl "http://xxx:9000/pg_backup"
##