from datetime import datetime
from functools import lru_cache
from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import HTMLResponse

from data import get_data

app = FastAPI()

cached_data = lru_cache(10)(lambda x: get_data())


def read_file(path):
    with open(path, 'r', encoding='utf8') as file:
        return file.read()


@app.get("/", response_class=HTMLResponse)
async def root():
    return read_file(str(Path('src') / 'index.html'))


@app.get("/src/{path}", response_class=HTMLResponse)
async def read_item(path):
    return read_file(str(Path('src') / path))


@app.get('/data')
async def root():
    return cached_data(datetime.now().strftime('%Y-%m-%d %H-%M'))
