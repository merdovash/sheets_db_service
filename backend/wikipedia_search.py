import configparser
from datetime import date
from functools import lru_cache
from typing import Optional

import requests

S = requests.Session()

config = configparser.ConfigParser()
config.read('settings.ini')


def _search(search_text: str) -> Optional[int]:
    """
    :param search_text:
    :return: pageId if search text is presented in title
    """
    if not search_text:
        return None

    params = {
        "action": "query",
        "format": "json",
        "list": "search",
        "srsearch": search_text
    }

    result = S.get(url=config['wikimedia']['api'], params=params)
    data = result.json()

    for page in data['query']['search']:
        title = page['title']
        if len(search_text.split(' ')) > 1:
            if all(word in title for word in search_text.split(' ')):
                return page['pageid']
        elif search_text in title:
            return page['pageid']


def page_url(search_text: str) -> Optional[str]:
    """
    :param search_text:
    :return: page url if page is found
    """
    page_id = _search(search_text)
    if page_id:
        return f'http://ru.wikipedia.org/?curid={page_id}'


_cached_page_url = lru_cache(100)(lambda x, y: page_url(x))


def cached_wikipedia_page_url(search_text: str) -> Optional[str]:
    """
    cache page_url for one day
    :param search_text:
    :return: same as page_url
    """
    return _cached_page_url(search_text, date.today().isoformat())
