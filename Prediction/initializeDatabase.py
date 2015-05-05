# database imports
from pymongo import MongoClient

import os, shutil

# init database connection
client  = MongoClient() # local host, default port
db = client.exploreSMU # database with labeledinstances, models

db.drop_collection('locations')

root = "./Landmarks/"

if os.path.exists(root):
    shutil.rmtree(root)
os.makedirs(root)



locations = [
	["Lyle School of Engineering", ["Wall of Patents", "Lyle Seal", "Hunt Center", "Ampitheater", "Caruth", "Embrey", "Office of Recruitment","Junkins"]],
	["Meadows School of Arts", []], 
	["Cox School of Business", []],
	["Dedman School of Humanities", []],
	["Student Services", ["Centennial Pavilion", "Cooper Centennial Fountain"]],
	["Athletics", ["Lloyd All Sports Center", "Gerald J. Ford Stadium", "Doak Walker Plaza", "Dedman Rec Center", "Moody Coliseum", "Peruna Statue"]],
	["Meadows Museum", ["La Joie de Vivre", "Figure with Raised Hands", "Crouching Woman", "Three Piece Reclining Figure", "Sho", "Horse and Rider", "Geometric Mouse", "Spirit's Flight"]],
	["Fondren Library", []],
	["Residential Commons", []],
	["Testing", ["Starbucks", "Blue Cups", "Candle", "Remote", "Ball"]]
]

for loc in locations:
	print "loc:", loc[0], "landmarks:", loc[1]

	db.locations.insert(
		{
			"location": loc[0],
			"landmarks": loc[1]
		}
	)

	for landmark in loc[1]:
		os.makedirs(root+loc[0]+"/"+landmark)
