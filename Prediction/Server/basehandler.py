#!/usr/bin/python

# tornado imports
import tornado.web

from tornado.web import HTTPError
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado.options import define, options
from tornado.escape import recursive_unicode

import datetime
import decimal
import json
import os
import os.path

from grp import getgrnam
from pwd import getpwnam


def json_str(value):
    return str(json.dumps(recursive_unicode(value), cls=CustomJSONEncoder).replace("</", "<\\/"))

class CustomJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            return obj.isoformat()
        elif isinstance(obj, datetime.date):
            return obj.isoformat()
        elif isinstance(obj, decimal.Decimal):
            return str(obj)
        else:
            return super(CustomJSONEncoder, self).default(obj)

class HTTPJSONError(Exception):
    """An exception that will turn into an HTTP error response."""
    def __init__(self, status_code, log_message=None, *args):
        self.status_code = status_code
        self.log_message = log_message
        self.args = args

    def __str__(self):
        message = {'error_code': self.status_code}
        if self.log_message:
            message['error_message'] = self.log_message % self.args
        return json_str(message)

class BaseHandler(tornado.web.RequestHandler):
    def get(self):
        '''Default get request, return a 404
           HTTP error
        '''

        self.write("Welcome to exploreSMU Learn Server")
        self.write("\nPost options:")
        self.write("\n\t* AddLandmarkData - input: dsid (location), feature (base64 image), label (landmark)")
        self.write("\n\t* PredictLandmark - input: dsid (location), feature (base64 image)")
        self.write("\nGet options:")
        self.write("\n\t* GetLocations - input: {none}")
        self.write("\n\t* GetLandmarks - input: dsid (location)")
            # "\nPost options:"
            # "\n\t* AddLandmarkData - input: dsid (location), feature (base64 image), label (landmark)"
            # "\n\t* PredictLandmark - input: dsid (location), feature (base64 image)"
            # "\nGet options:"
            # "\n\t* GetLocations - input: {none}"
            # "\n\t* GetLandmarks - input: dsid (location)")
        # raise HTTPError(404)

    @property
    def db(self):
        '''Instance getter for database connection
        '''
        return self.application.db

    @property
    def clf(self):
        '''Instance getter for classifier in sklearn 
        '''
        return self.application.clf

    @clf.setter
    def clf(self,clfin):
        '''Instance setter for current classifier 
        '''
        self.application.clf = clfin

    @property
    def client(self):
        '''Instance getter for database connection
        '''
        return self.application.client

    def get_int_arg(self, value, default=[], strip=True):
        '''Convenience method for grabbing integer arguments
           from HTTP headers. Will raise an HTTP error if
           argument is missing or is not an integer
        '''
        try:
            arg = self.get_argument(value, default, strip)
            return default if arg == default else int(arg) 
        except ValueError:
            e = "%s could not be read as an integer" % value
            raise HTTPJSONError(1, e)

    def get_long_arg(self, value, default=[], strip=True):
        '''Convenience method for grabbing long integer arguments
           from HTTP headers. Will raise an HTTP error if
           argument is missing or is not an integer
        '''
        try:
            arg = self.get_argument(value, default, strip)
            return default if arg == default else long(arg)
        except ValueError:
            e = "%s could not be read as a long integer" % value
            raise HTTPJSONError(1, e)

    def get_float_arg(self, value, default=[], strip=True):
        '''Convenience method for grabbing long integer arguments
           from HTTP headers. Will raise an HTTP error if
           argument is missing or is not an integer
        '''
        try:
            arg = self.get_argument(value, default, strip)
            return default if arg == default else float(arg)
        except ValueError:
            e = "%s could not be read as a long integer" % value
            raise HTTPJSONError(1, e)

    def write_json(self, value={}):
		'''Completes header and writes JSONified 
		   HTTP back to client
		'''
		self.set_header("Content-Type", "application/json")
		tmp = json_str(value);
		# print tmp
		self.write(tmp)



