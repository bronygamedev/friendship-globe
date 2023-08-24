import sqlite3
import uvicorn
from fastapi import *
from fastapi.responses import *
from datetime import datetime
from pydantic import BaseModel


app = FastAPI()

# DB settup
print("DB Init")
DB = sqlite3.connect("sql.db")
cursor = DB.cursor()


class point(BaseModel):
    x: float
    y: float
    z: float
    day: int


def check_for_table(name: str):
    try:
        data = cursor.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?", (name,)
        ).fetchall()
    except Exception as e:
        print(e)
    finally:
        return data == []


def get_id():
    return cursor.execute(f"SELECT MAX(id) FROM points").fetchall()


@app.get("/", response_class=HTMLResponse)
async def root():
    with open("index.html", "r") as f:
        return f.read()


@app.post("/api/set_point")
async def set_points(data: point):
    try:
        id = get_id()
        print(id)
        cursor.execute(f"INSERT INTO points (x,y,z,day) VALUES (0,0,0,23)")
        DB.commit()
    except Exception as ex:
        raise HTTPException(status_code=500, detail=ex)
    return HTTPException(200)


@app.get("/api/get_points")
async def get_points():
    day = datetime.now().day
    print(day)
    return cursor.execute(f"SELECT * FROM points;").fetchall()


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
    uvicorn.run("server:app", port=2010, reload=True, access_log=True)
