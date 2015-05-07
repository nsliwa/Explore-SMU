import PIL
from PIL import Image
from os import walk
import os, sys
import base64
from pymongo import MongoClient

client  = MongoClient() # local host, default port
db = client.exploreSMU # database with labeledinstances, models

root = "./Landmarks/"

for (dirpath, dirnames, filenames) in walk(root):
	for (directory_path, directory_names, file_names) in walk(dirpath):
	    if dirpath != directory_path:
	    	for f in file_names:
	    		if f != ".DS_Store":

	    			path =  directory_path+"/"+f

	    			print directory_path
	    			print directory_path.split(root)
	    			print directory_path.split(root)[1].split("/")

	    			dsid = directory_path.split(root)[1].split("/")[0]
	    			label = directory_path.split(root)[1].split("/")[1]

	    			print "path:", directory_path.split(root)[1].split("/")
	    			print path

	    			dbid = None

	    			img = Image.open(path)
	    			img = img.resize((100, 100), PIL.Image.ANTIALIAS)
	    			img.save(path)