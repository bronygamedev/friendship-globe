import json
import os
import sqlite3
import sys
import threading
from datetime import datetime, timedelta
import subprocess
import uvicorn
from fastapi import *
from fastapi.responses import *
from pydantic import BaseModel

app = FastAPI()

yesterday = None
today = datetime.now().day
# DB settup
print("DB Init")
DB = sqlite3.connect("sql.db")
cursor = DB.cursor()
running = True
reload = False


class point(BaseModel):
    x: float
    y: float
    z: float


def placeholder():
    while running:
        pass


def resetdb():
    pass


def check_for_table(name: str):
    try:
        data = cursor.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?", (name,)
        ).fetchall()
    except Exception as e:
        print(e)
    finally:
        return data == []


@app.on_event("startup")
async def startup():
    print("running")
    # checking if table exists if not creates a table named points
    if check_for_table("points"):
        cursor.execute(
            "CREATE TABLE points (id INTEGER PRIMARY KEY, x REAL, y REAL, z REAL,day INTEGER);"
        )
        cursor.execute("INSERT INTO points VALUES (1,0,0,0,31)")
        DB.commit()
        print(cursor.execute("""SELECT * FROM points""").fetchall())
    #threading.Thread(target=placeholder).start()


@app.get("/", response_class=HTMLResponse)
async def index(_request: Request):
    return '<html lang="en"> <head> <meta charset="UTF-8"all > <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Friendship globe server</title> <link rel="icon" type="image/png" href="https://cdn-icons-png.flaticon.com/512/157/157359.png"> <style> body { margin: auto; width: 50%; padding: 10px; text-align: center; background-color: gray; } </style> </head> <body> <h1>hello nothing here</h1> <h2><a href="/docs">server auto generated docs</a></h2> </body> </html>'


@app.post("/api/set_point")
async def set_points(data: point):
    print(data)
    try:
        cursor.execute(
            f"INSERT INTO points (x,y,z,day) VALUES ({data.x},{data.y},{data.z},{today})"
        )
        DB.commit()
    except Exception as ex:
        raise HTTPException(status_code=500, detail=ex)
    return HTTPException(200)


@app.get("/api/get_points")
async def get_points(request: Request):
    print("getting data")
    data = cursor.execute(f"SELECT * FROM points;").fetchall()
    json_data = json.dumps(data)
    # print(data, " ", json_data, " ", day, " ", request.headers)
    return data

if __name__ == "__main__":
    uvicorn.run("server:app", port=2010, reload=True, workers=4)
    running = False
    sys.exit()
