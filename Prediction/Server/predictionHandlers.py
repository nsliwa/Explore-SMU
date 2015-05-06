#!/usr/bin/python

# database imports
from pymongo import MongoClient

import json

# image decoding
import base64
import numpy as np
from io import BytesIO
from PIL import Image
import cv2

# model saving
import gridfs
import pickle
from bson.binary import Binary

import tornado.web

from tornado.web import HTTPError
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado.options import define, options

from basehandler import BaseHandler

from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC

from sklearn.grid_search import GridSearchCV

# skimage imports
from skimage.feature import hog
from skimage import data, color, exposure

class GetLocationsHandler(BaseHandler):
	def get(self):
		'''GetLocations
		'''

		locations=[]
		for loc in self.db.locations.find( {"location": { "$exists": True } } ):
			location = loc["location"]
			locations.append( location )

		print "getting locations:", locations

		self.write_json( {"locations": locations} )

class GetLandmarksHandler(BaseHandler):
	def get(self):
		'''GetLandmarks
		'''

		dsid = self.get_argument("dsid", default="Testing", strip=True)

		print "dsid:", dsid

		data = self.db.locations.find_one( {"$and": [ {"location": {"$exists": True}}, {"location": dsid} ]} )
		print "data:", data
		landmarks = data["landmarks"]

		print "getting landmarks from", dsid, ":", landmarks

		self.write_json( {"landmarks": landmarks} )


class AddLearningDataHandler(BaseHandler):
	# @tornado.web.asynchronous
	def post(self):
		'''AddLearningData
		'''
		# get json from post
		data = json.loads(self.request.body)

		# parse out 1st lvl json
		dsid = data["dsid"]
		label = data["label"]
		feature_data = data["feature"]

		# parse out 2nd lvl json (img inside data)
		# keep as base64 encode
		# feature now directly contains img data (don't parse out img from dict)
		feature_data = feature_data["img"]

		dbid = self.db.labeledinstances.insert(
			{
				"feature":feature_data,
				"label":label,
				"dsid":dsid
			}
		)

		print "added instance: dsid -", dsid, "label-", label

		self.write_json({"label":data["label"]})


class PredictLocationHandler(BaseHandler):
	def get(self):
		'''PredictLocation
		'''
		self.write("Need to use post request!")		


	def post(self):
		'''PredictLocation
		'''
		
		# get json from post
		data = json.loads(self.request.body)

		# parse out 1st lvl json
		dsid = data['dsid']
		feature_data = data["feature"]

		print "dsid: ", dsid

		# parse out 2nd lvl json (img inside data)
		feature_data = feature_data["img"]

		# decode current img from base64
		# convert to np array
		img = Image.open(BytesIO(base64.b64decode(feature_data)))
		# downsample
		width = 100
		height = 100
		img = img.resize((width, height), Image.ANTIALIAS)
		# convert to numpy array
		img = np.array(img)

		# convert img to grayscale
		# gray = color.rgb2gray(img)
		gray= cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
		gray = gray.astype(np.float)

		# process hog
		fd, hog_img = hog(gray, orientations=8, pixels_per_cell=(32,32), cells_per_block=(1,1), visualise=True)

		# convert to numpy array and reshape
		gray = np.array(hog_img)
		gray = gray.astype(np.float)


		# http://alexk2009.hubpages.com/hub/Storing-large-objects-in-MongoDB-using-Python
		# create a new gridfs object.
		fs = gridfs.GridFS(self.db)

		# tmp = self.db.models.find_one({"dsid":dsid});
		# pca_id = tmp['pca']

		# # retrieve model that was stored using model_id
		# # unpickle binary
		# storedPCA = fs.get(pca_id).read()
		# pca_retrieved = pickle.loads(storedPCA);

		# reshape img array into 1d array
		# apply pca transform
		# fvals now contains feature data for prediction
		fvals = gray.reshape( (1, -1) )[0]
		# fvals = pca_retrieved.transform(fvals)
		

		# load model from memory if exists, else:
		# load the model from the database (using pickle and GridFS)

		# if memory models !empty but dsid !exist in db
		if(not self.clf == []):
			if(self.clf.get(dsid) is None):
				print 'Loading Model From DB'
				tmp = self.db.models.find_one({"dsid":dsid})
				model_id = tmp['model']

				# http://alexk2009.hubpages.com/hub/Storing-large-objects-in-MongoDB-using-Python
				# create a new gridfs object.
				fs = gridfs.GridFS(self.db)

				# retrieve model that was stored using model_id
				# unpickle binary
				storedModel = fs.get(model_id).read()
				model = pickle.loads(storedModel)

				# store for later
				self.clf[dsid] = model

		# if memory models not initialized
		else:
			print 'Loading Model From DB and Initializing'
			tmp = self.db.models.find_one({"dsid":dsid})
			model_id = tmp['model']

			# retrieve model that was stored using model_id
			# unpickle binary
			storedModel = fs.get(model_id).read()
			model = pickle.loads(storedModel)

			# initialize memory models
			self.clf = {dsid: model}
		
		model = self.clf[dsid]
		print "dsid: ", dsid, " | model data: ", model

		if model:
			print model.coef_
			print np.shape(model)
		
		# predicted label
		predLabel_id = model.predict(fvals)
		landmarks = self.db.locations.find_one( {"location": dsid} )
		landmarks = landmarks["landmarks"]
		predLabel = landmarks[ int(predLabel_id[0]) ]

		# predLabel = self.db.locations.find_one({"location_id":int(predLabel_id[0])});
		# predLabel = predLabel["location"]

		print "predicted label: ", predLabel

		self.write_json({"label":predLabel})
