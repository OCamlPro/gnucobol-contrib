import os
from ctypes import c_char_p, c_ulong, CDLL, pointer, windll
from bpedit.utils.load_env import EnvLoader
from bpedit.utils.string_utils import find_last_occur


class DebugModuleLoader:
    lib = None
    moduleName = ''
    lib_path = None

    def __init__(self, module_name):
        self.moduleName = module_name[:find_last_occur(module_name, '.')]
        self.lib_path = EnvLoader().get_src_folder()
        full_path = os.path.join(self.lib_path, module_name)
        print('loading module: %s' % full_path)
        try:
            self.lib = CDLL(full_path)
        except OSError:
            self.lib = None

    def get_module_line_count(self):
        if self.lib is None:
            return None

        func = getattr(self.lib, 'get_linecount_{}'.format(self.moduleName), None)
        if func is None:
            return None

        return func()

    def is_loaded(self):
        if self.lib is None:
            return False
        return True

    def get_src_line(self, line_nbr):
        if self.lib is None:
            return None

        tmp = b' ' * 256
        response_buffer = c_char_p(tmp)
        c_line_nr_ptr = pointer(c_ulong(line_nbr))

        func = getattr(self.lib, 'get_aniline_{}'.format(self.moduleName))
        # getattr raises AttributeError but we check for debugging symbols after call to get_module_line_count
        func(c_line_nr_ptr, response_buffer)

        try:
            # todo need to add a setting for user to set encoding?
            res = 6 * ' ' + response_buffer.value.decode('latin-1').rstrip()
        except UnicodeDecodeError:
            res = '      * Decoding error'

        return res

    def __del__(self):
        if self.lib is None:
            return None

        handle = self.lib._handle  # object handle to so/dll
        if os.name == 'nt':
            windll.kernel32.FreeLibrary(handle)
        else:
            cdll.LoadLibrary('libdl.so').dlclose(handle)
