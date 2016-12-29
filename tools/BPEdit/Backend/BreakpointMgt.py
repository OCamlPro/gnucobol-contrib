#-*- coding: utf-8 -*-
'''
Created on 04.03.2015

@author: pboehme
'''

from Utils.LoadEnv import EnvLoader
from Utils.StringUtils import find_last_occur
import os

class BPMgr():
    bp_dict = {} # Structure {'sourcefile': [linenumber]}
    env = None    
    pd_line = 0
    
    def __init__(self, env_loader = None):
        if env_loader:
            self.env = env_loader 
        else:
            self.env = EnvLoader()
            
        self.__loadAllBreakpoints()
    
    def __loadAllBreakpoints(self):
        try:
            f = open(self.env.getBPFile())
            for bpline in f:
                splittedLine = bpline.split(';')
                if not splittedLine[0] in self.bp_dict.keys():
                    self.bp_dict[splittedLine[0]] = []
                self.bp_dict[splittedLine[0]].append(splittedLine[1].strip())    
            f.close()
        except OSError:
            print('Could not initialize Breakpoints ...')
    
    def loadBreakpoints(self, filepath):
        filename = os.path.basename(filepath)
        pos = find_last_occur(os.path.basename(filename), '.')
        
        if not filename[:pos] in self.bp_dict.keys():
            return None
        return self.bp_dict[filename[:pos]]
    
    def saveBreakpoints(self, bp_tuple):
        self.bp_dict[bp_tuple[0][:find_last_occur(bp_tuple[0], '.')]] = bp_tuple[1]
        self.__writeBreakpoints()
        
    def __writeBreakpoints(self):
        try:
            f = open(self.env.getBPFile(), 'w')
            for bp_file, bp_list in self.bp_dict.items():
                for row in bp_list:
                    f.write('{0};{1:05d}\n'.format(bp_file, int(row)))
            f.close()
        except OSError:
            print('Could not write Breakpoints ...')
