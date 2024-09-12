import pandas as pd 

from os import getenv
from dotenv import load_dotenv
from models.Database import Database
from models.Scrapping import Scrapping
from models.Shp import Shp

CHUNKSIZE = 1000
TABLENAME = 'foco_queimada_municipio'
URL_INPE = 'https://dataserver-coids.inpe.br/queimadas/queimadas/focos/csv/10min/'
DATA_INICIAL = '2024-09-01'

load_dotenv()

try:
    db = Database(host=getenv('MYSQL_HOST'),port=getenv('MYSQL_PORT'),user=getenv('MYSQL_USER'),password=getenv('MYSQL_PASSWORD'),database=getenv('MYSQL_DATABASE'))
    db.connect()

    scrapping = Scrapping(URL_INPE)
    scrapping.request_content_page()
    scrapping.filter_page_based_tag_html()
    scrapping.read_files_csv().to_csv('../points.csv',sep=';',index=False)

    shp = Shp()
    shp.read_shp('/BR_Municipios_2022/BR_Municipios_2022.shp')

    data = shp.join_points_inner_city('../points.csv')

    filter_data = data[data['CD_MUN'].notna()]
    filter_data = data[data['SIGLA_UF'] == 'SP']

    df_final = filter_data[['nr_latitude','nr_longitude','dt_foco','CD_MUN']]
    df_final = df_final.rename(columns={'CD_MUN': 'cd_municipio'})

    db.delete(f"delete from {TABLENAME} where cast(dt_foco as date) >= '{DATA_INICIAL}'")
    
    df_final.to_sql(name=TABLENAME,con=db.connection,chunksize=CHUNKSIZE,if_exists='append', index=False)
    
    db.close()
except Exception as e:
    print(e)