import os
from ctypes import c_char_p, c_ulong, CDLL, pointer
from bpedit.utils.load_env import EnvLoader
from bpedit.utils.string_utils import find_last_occur

try:
    from _ctypes import LoadLibrary
    from _ctypes import FreeLibrary

    def load_library(module_name, lib_path):
        return LoadLibrary(os.path.join(lib_path, module_name))

    def free_library(lib):
        free_library(lib._handle)

except ImportError:
    def load_library(module_name, lib_path):
        return CDLL(os.path.join(lib_path, module_name))

    def free_library(lib):
        del lib


class DebugModuleLoader:
    lib = None
    moduleName = ''
    lib_path = None
    
    def __init__(self, module_name):
        self.moduleName = module_name[:find_last_occur(module_name, '.')]
        self.lib_path = EnvLoader().get_src_folder()
        self.lib = load_library(module_name, self.lib_path)
        
    def get_module_line_count(self):
        func = getattr(self.lib, 'get_linecount_{}'.format(self.moduleName))
        return func()
    
    def load_module(self, module_name):
        # first unload the current module
        if self.lib:
            free_library(self.lib)
        self.lib = load_library(module_name, self.lib_path)
        
    def unload_module(self):
        if self.lib:
            free_library(self.lib)
            
    def get_src_line(self, line_nbr):
        tmp = b' ' * 256
        response_buffer = c_char_p(tmp)
        c_line_nr_ptr = pointer(c_ulong(line_nbr))
        
        func = getattr(self.lib, 'get_aniline_{}'.format(self.moduleName))
        func(c_line_nr_ptr, response_buffer)
    
        try:
            # todo need to add a setting for user to set encoding?
            res = 6 * ' ' + response_buffer.value.decode('latin-1').rstrip()
        except UnicodeDecodeError:
            res = '      * Decoding error'

        return res
