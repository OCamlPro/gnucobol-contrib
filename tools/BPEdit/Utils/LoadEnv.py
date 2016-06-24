#-*- coding: -*- coding: utf-8 -*-

'''
Created on 03.03.2015

@author: pboehme
'''

import os

class EnvLoader():
    env_dict = {'bp_file': None, 'src_folder': None, 'ui_file': None, 'libcob_path': None}
        
    def __init__(self):
        self.__loadConfig()
    
    def __loadConfig(self):
#         f = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../paths.ini'), 'r')
        f = open('paths.ini', 'r')
        if f:
            for line in f.readlines():
                if line[0] == '#' or line[0] == ';': 
                    continue
                splittedLine = line.split('=')
                if self.env_dict.__contains__(splittedLine[0].strip()):
                    self.env_dict[splittedLine[0].strip()] = splittedLine[1].strip()
        f.close()
        
        
    def getBPFile(self):
        return self.env_dict['bp_file']
    
    def getSrcFolder(self):
        return self.env_dict['src_folder']
    
    def getUIFile(self):
        return self.env_dict['ui_file']    
    
    def initializePath(self):
        path = os.environ.get('PATH', '-1')
        os.environ['PATH'] = '{};{};{}'.format(path, self.getSrcFolder(), self.env_dict['libcob_path'])
    
    
