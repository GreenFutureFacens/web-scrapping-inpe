import requests 
import pandas as pd

from bs4 import BeautifulSoup

class Scrapping:

    def __init__(self, url: str) -> None:
        self.url = url
        self.content_page = ""
        self.files_to_download = []
        self.dataframe = pd.DataFrame()

    def request_content_page(self):
        self.content_page = requests.get(url=self.url).text

    def pattern_to_download(self, attribute_html: BeautifulSoup, key:str) -> bool:
        if attribute_html.has_attr(key) == False:
            return False
        
        attribute = str(attribute_html[key])

        if attribute.endswith('.csv') == False:
            return False
        
        return True
    
    def filter_page_based_tag_html(self):
        soup = BeautifulSoup(self.content_page, 'html.parser')
        a_tags = soup.find_all('a',href=True)

        for a in a_tags:
            if self.pattern_to_download(a, 'href'):
                self.files_to_download.append(self.url + a['href'])

    def read_files_csv(self, limit:int = 0) -> pd.DataFrame:
        dfs = []
        i = 0

        for file in self.files_to_download:
            try:
                dfs.append(pd.read_csv(file,dtype=str,usecols=['lat','lon','data']))
            except:
                pass
            
            if limit > 0:
                i += 1

                if i >= limit:
                    break

        
        self.dataframe = pd.concat(dfs, ignore_index=True)
        self.dataframe = self.dataframe.rename(columns={'lat':'nr_latitude','lon':'nr_longitude','data':'dt_foco'})
        return self.dataframe