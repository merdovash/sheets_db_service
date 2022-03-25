from pathlib import Path

from fastapi import FastAPI, Response
from fastapi.responses import HTMLResponse, JSONResponse

from sheets import cached_sheet_data
from wikipedia_search import cached_wikipedia_page_url

app = FastAPI()


def read_file(path):
    with open(path, 'r', encoding='utf8') as file:
        return file.read()


@app.get("/", response_class=HTMLResponse)
async def root():
    return read_file(str(Path('src') / 'index.html'))


@app.get("/src/{path}", response_class=HTMLResponse)
async def read_item(path):
    return read_file(str(Path('src') / path))


@app.get('/data', response_class=JSONResponse)
async def root(response: Response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    result = cached_sheet_data()
    for res in result:
        name = res.get('name')
        if not name:
            continue
        wikipedia_url = cached_wikipedia_page_url(name)
        if not wikipedia_url:
            continue
        res['wikipedia'] = wikipedia_url

    return result


@app.get('/wikipedia/{name}')
async def wikipedia(name):
    return cached_wikipedia_page_url(name)
