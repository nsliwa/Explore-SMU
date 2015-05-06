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
	["Lyle School of Engineering", ["Dean's Suite", "Ampitheater", "Hunt Institute", "Innovation Gym", "Junkins", "Lyle", "Lyle Seal", "Office of Recruitment", "Wall of Patents"]],
	["Meadows School of Arts", []], 
	["Cox School of Business", []],
	["Dedman School of Humanities", []],
	["Student Services", ["Centennial Pavilion", "Cooper Centennial Fountain"]],
	["Athletics", ["Lloyd All Sports Center", "Gerald J. Ford Stadium", "Doak Walker Plaza", "Dedman Rec Center", "Moody Coliseum", "Peruna Statue"]],
	["Meadows Museum", ["Crouching Woman", "Figure with Raised Arms", "Geometric Mouse II", "Horse and Rider", "Spirit's Flight", "Three Piece Reclining Figure"]],
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
