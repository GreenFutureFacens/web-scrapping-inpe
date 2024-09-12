import geopandas as gpd
import pandas as pd
from shapely.geometry import Point 

class Shp:

    def __init__(self) -> None:
        self.dir_name = '/Users/felipelima/Documents/Projects/Python/web-scrapping-inpe/assets/shp'
        self.shp = None 
        self.fields = []

    def read_shp(self, name: str):
        self.shp = gpd.read_file(self.dir_name + name)
    
    def join_points_inner_city(self,csv: str) -> gpd.GeoDataFrame:
        points_csv = gpd.read_file(csv)
        points_csv = gpd.GeoDataFrame(points_csv, geometry=gpd.points_from_xy(points_csv.nr_longitude, points_csv.nr_latitude))

        pontos = points_csv.set_crs(self.shp.crs)

        return gpd.sjoin(pontos,self.shp, how='left',predicate='within')
