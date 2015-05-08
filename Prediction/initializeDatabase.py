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
	["Residential Commons", ["Residential Commons Armstrong", "Residential Commons Blue Light", "Residential Commons Band Hall", "Residential Commons Crow", "Residential Commons Loyd"]],
	["Athletics", ["Athletics Dedman Rec Center", "Athletics Doak Walker Plaza", "Athletics Moody Coliseum", "Athletics Peruna", "Athletics Soccer Field"]],
	["Meadows Museum", ["Meadows M Figure with Raised Arms", "Meadows M Crouching Woman", "Meadows M Three Piece Reclining Figure", "Meadows M Horse and Rider", "Meadows M Geometric Mouse II", "Meadows M Spirit's Flight"]], 
	["Perkins School of Theology", ["Perkins Chapel", "Perkins Chapel Garden", "Perkins Library Entrance"]],
	["Meadows School of Arts", ["Meadows", "Meadows Entrance Painting", "Meadows Auditorium", "Meadows Entrance Art", "Meadows Tech Effect", "Meadows Painting", "Meadows Lounge", "Meadows Library", "Meadows Creative Computing"]],
	["Cox School of Business", ["Cox", "Cox Quad", "Cox Quad Entrance", "Cox Trade", "Cox Alumni", "Cox Computer Lab", "Cox Networking", ]],
	["Dedman School of Humanities", ["Dedman", "Dedman Dallas Hall Entrance", "Dedman Dallas Hall Seal", "Dedman Dallas Hall Portrait"]],
	["Lyle School of Engineering", ["Lyle", "Lyle Hunt Institute", "Lyle Innovation Gym", "Lyle Seal", "Lyle Wall of Patents", "Lyle Ampitheater", "Lyle Dean's Suite", "Lyle Office of Recruitment", "Lyle Junkins"]],
	["Hughes Trigg Student Center", ["Hughes Trigg Commons", "Hughes Trigg M Lounge", "Hughes Trigg Peruna Statue", "Hughes Trigg Cafe 100", "Hughes Trigg Mail", "Hughes Trigg Mane Course", "Hughes Trigg Basement", "Hughes Trigg SMU Unbridled"]],
	["Blanton Student Servies", ["Blanton Fountain", "Blanton Entrance", "Blanton Building Number", "Blanton Cooper Centennial Fountain", "Blanton Centennial Pavilion"]]
	
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
