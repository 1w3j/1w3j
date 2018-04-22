#!/usr/bin/env python3

""" simple script for checking out the availability
    of innings in the new argentinian reservation system 
    of Ministerio de Educacion
"""

import requests
from pyquery import PyQuery

r=requests.get("http://titulosvalidez.educacion.gob.ar/validez/v_turnos/inicio12.php")
html=r.text
pq=PyQuery(html)
text=pq("center").text()
print(text)
