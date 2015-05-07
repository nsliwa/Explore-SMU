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

	# ["Athletics", ["Athletics Dedman Rec Center", "Athletics Doak Walker Plaza", "Athletics Moody Coliseum", "Athletics Peruna", "Athletics Soccer Field"]],
	# ["Blanton Student Servies", ["Blanton Building Number", "Blanton Centennial Pavilion", "Blanton Cooper Centennial Fountain", "Blanton Entrance", "Blanton Fountain"]],
	# ["Cox School of Business", ["Cox", "Cox Alumni", "Cox Computer Lab", "Cox Networking", "Cox Quad", "Cox Quad Entrance", "Cox Trade"]],
	["Dedman School of Humanities", ["Dedman", "Dedman Dallas Hall Entrance", "Dedman Dallas Hall Portrait", "Dedman Dallas Hall Seal", "Hughes Trigg Student Center"]],
	["Hughes Trigg Student Center", ["Hughes Trigg Basement", "Hughes Trigg Cafe 100", "Hughes Trigg Commons", "Hughes Trigg M Lounge", "Hughes Trigg Mail", "Hughes Trigg Mane Course", "Hughes Trigg Peruna Statue", "Hughes Trigg SMU Unbridled"]],
	# ["Lyle School of Engineering", ["Lyle", "Lyle Ampitheater", "Lyle Dean's Suite", "Lyle Hunt Institute", "Lyle Innovation Gym", "Lyle Junkins", "Lyle Office of Recruitment", "Lyle Seal", "Lyle Wall of Patents"]],
	# ["Meadows Museum", ["Meadows M Crouching Woman", "Meadows M Figure with Raised Arms", "Meadows M Geometric Mouse II", "Meadows M Horse and Rider", "Meadows M Spirit's Flight", "Meadows M Three Piece Reclining Figure"]], 
	# ["Meadows School of Arts", ["Meadows", "Meadows Auditorium", "Meadows Creative Computing", "Meadows Entrance Art", "Meadows Entrance Painting", "Meadows Library", "Meadows Lounge", "Meadows Painting", "Meadows Tech Effect"]],
	# ["Perkins School of Theology", ["Perkins Chapel", "Perkins Chapel Garden", "Perkins Library Entrance"]],
	# ["Residential Commons", ["Residential Commons Armstrong", "Residential Commons Band Hall", "Residential Commons Blue Light", "Residential Commons Crow", "Residential Commons Loyd"]]


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
