#!/usr/bin/python
'''Starts and runs the scikit learn server'''

# For this to run properly, MongoDB must be running
# something like $./mongod --dbpath "../data/db"

# database imports
from pymongo import MongoClient

# tornado imports
import tornado.web
from tornado.web import HTTPError
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado.options import define, options

# custom imports
from basehandler import BaseHandler
import predictionHandlers

# Setup information for tornado class
define("port", default=8000,
       help="run on the given port", type=int)

# Utility to be used when creating the Tornado server
# Contains the handlers and the database connection
class Application(tornado.web.Application):
    def __init__(self):
	'''Store necessary handlers,
	   connect to database
	'''
    
        handlers = [(r"/[/]?", 
                        BaseHandler),

                    (r"/GetLocations[/]?",
                        predictionHandlers.GetLocationsHandler), 
                    (r"/GetLandmarks[/]?",
                        predictionHandlers.GetLandmarksHandler), 

                    (r"/AddLearningData[/]?",
                        predictionHandlers.AddLearningDataHandler), 
                    (r"/PredictLocation[/]?",
                        predictionHandlers.PredictLocationHandler)    
                    ]

        settings = {'debug':True}
        tornado.web.Application.__init__(self, handlers, **settings)

        self.client  = MongoClient() # local host, default port
        self.db = self.client.exploreSMU # sklearndatabase # database with labeledinstances, models
        self.clf = []

        #self.client.close() # this opened a socket -- lets close that connection

    def __exit__(self):
        self.client.close() # just in case


def main():
    '''Create server, begin IOLoop 
    '''
    tornado.options.parse_command_line()
    http_server = HTTPServer(Application(), xheaders=True)
    http_server.listen(options.port)
    IOLoop.instance().start()

if __name__ == "__main__":
    main()
