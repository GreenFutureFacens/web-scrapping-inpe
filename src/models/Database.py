import pandas as pd 
from sqlalchemy import create_engine,text
from urllib.parse import quote_plus
class Database:

    def __init__(self,host: str, port: int, user: str, password: str, database: str) -> None:
        self.host = host 
        self.port = port 
        self.user = user 
        self.password = quote_plus(password)
        self.database = database

        self.connection = None

    def connect(self):
        self.connection = create_engine(f'mysql+pymysql://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}')

    def close(self):
        self.connection.dispose()

    def delete(self,query:str):
        with self.connection.connect() as connect:
            with connect.begin() as transaction:
              try:
                connect.execute(text(query))
                transaction.commit()
              except Exception as e:
                transaction.rollback()
                print(f"Erro: {e}")

    def proc(self,query:str):
        with self.connection.connect() as connect:
            with connect.begin() as transaction:
              try:
                connect.execute(text(query))
                transaction.commit()
              except Exception as e:
                transaction.rollback()
                print(f"Erro: {e}")
        