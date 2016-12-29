#-*- coding: utf-8 -*-

'''
Created on 04.03.2015

@author: pboehme
'''

import os
try:
    from _ctypes import LoadLibrary as win32LoadLibrary
    from _ctypes import FreeLibrary as win32FreeLibrary

    def LoadLibrary(moduleName, libPath):
        return win32LoadLibrary(os.path.join(libPath, moduleName))

    def FreeLibrary(lib):
        win32FreeLibrary(lib._handle)

except ImportError:
    def LoadLibrary(moduleName, libPath):
        return CDLL(os.path.join(libPath, moduleName))

    def FreeLibrary(lib):
        del lib

from ctypes import c_char_p, c_ulong, CDLL, pointer
from Utils.LoadEnv import EnvLoader
from Utils.StringUtils import find_last_occur


class DebugModuleLoader():
    lib = None
    moduleName = ''
    libPath = None
    
    def __init__(self, moduleName):
        self.moduleName = moduleName[:find_last_occur(moduleName, '.')]
        self.libPath = EnvLoader().getSrcFolder()
        self.lib = LoadLibrary(moduleName, self.libPath)
        
    def getModuleLineCount(self):
        print(dir(self.lib))
        func = getattr(self.lib, 'get_linecount_{}'.format(self.moduleName))
        return func()
    
    def loadModule(self, moduleName):
        # first unload the current module
        if self.lib:
            FreeLibrary(self.lib)
        self.lib = LoadLibrary(moduleName, self.libPath)
        
    def unloadModule(self):
        if self.lib:
            FreeLibrary(self.lib)
            
    def getSrcLine(self, lineNr):
        tmp = b' ' * 256
        responseBuffer = c_char_p(tmp)
        c_lineNr_ptr = pointer(c_ulong(lineNr))
        
        func = getattr(self.lib, 'get_aniline_{}'.format(self.moduleName))
        func(c_lineNr_ptr, responseBuffer)
    
        try:
            res = responseBuffer.value.decode('latin-1')
        except:
            res = '      * Dekodierungsfehler'    

        return res
