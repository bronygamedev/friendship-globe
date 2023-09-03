import json
import os
import sqlite3
import sys
import threading
from datetime import datetime, timedelta

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


@app.get("/", response_class=HTMLResponse)
async def root():
    with open("index.html", "r") as f:
        return f.read()


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
    data = cursor.execute(f"SELECT * FROM points;").fetchall()
    json_data = json.dumps(data)
    # print(data, " ", json_data, " ", day, " ", request.headers)
    return data


if __name__ == "__main__":
    # checking if table exists if not creates a table named points
    if check_for_table("points"):
        cursor.execute(
            "CREATE TABLE points (id INTEGER PRIMARY KEY, x REAL, y REAL, z REAL,day INTEGER);"
        )
        cursor.execute("INSERT INTO points VALUES (1,0,0,0,31)")
        DB.commit()
        print(cursor.execute("""SELECT * FROM points""").fetchall())
    print("starting server")
    threading.Thread(target=placeholder).run()
