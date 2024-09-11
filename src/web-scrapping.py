import pandas as pd 
import requests

from datetime import datetime
from bs4 import BeautifulSoup

URL_INPE = 'https://dataserver-coids.inpe.br/queimadas/queimadas/focos/csv/10min/'

def read_files_csv(list_names_files:list[str]) -> pd.DataFrame:
    dfs = []
    control = 0

    for file in list_names_files:
        try:
            df = pd.read_csv(file)
            dfs.append(df)
        except Exception as e:
            pass
        
        # in production comment the code below
        # control += 1 # comment

        # if control >= 10: #comment
        #     break
        
    df_final = pd.concat(dfs,ignore_index=True)

    return df_final

def get_content_page(url: str) -> str:
    response = requests.get(url=url)
    return response.text    

def filter_page_based_tag_html(html_content_string: str, url:str) -> list[str]:
    soup = BeautifulSoup(html_content_string,'html.parser')
    a_tags = soup.find_all('a', href=True)

    vet_files = []
    
    for a in a_tags:
        if a.has_attr('href') == False: 
            continue
        
        href = a['href']

        if href.endswith('.csv') == True: 
            vet_files.append(url + href)
    
    return vet_files

html_content = get_content_page(URL_INPE)
list_files = filter_page_based_tag_html(html_content, URL_INPE)
df = read_files_csv(list_files)
df.to_csv('queimadas_scrapping.csv',index=False,sep=';')