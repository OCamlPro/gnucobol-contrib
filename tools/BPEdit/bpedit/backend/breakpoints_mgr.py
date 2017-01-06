import os

from bpedit.utils.string_utils import find_last_occur
from bpedit.utils.load_env import EnvLoader


class BreakpointsManager:
    bp_dict = {}  # Structure {'sourcefile': [linenumber]}
    env = None    
    pd_line = 0
    
    def __init__(self, env_loader=None):
        if env_loader:
            self.env = env_loader 
        else:
            self.env = EnvLoader()
            
        self.__load_all_breakpoints()
    
    def __load_all_breakpoints(self):
        try:
            f = open(self.env.get_breakpoints_file())
            for bpline in f:
                splitted_line = bpline.split(';')
                if not splitted_line[0] in self.bp_dict.keys():
                    self.bp_dict[splitted_line[0]] = []
                self.bp_dict[splitted_line[0]].append(splitted_line[1].strip())
            f.close()
        except OSError:
            print('Could not initialize Breakpoints ...')
    
    def load_breakpoints(self, filepath):
        filename = os.path.basename(filepath)
        pos = find_last_occur(os.path.basename(filename), '.')
        
        if not filename[:pos] in self.bp_dict.keys():
            return []
        return self.bp_dict[filename[:pos]]
    
    def save_breakpoints(self, bp_tuple):
        self.bp_dict[bp_tuple[0][:find_last_occur(bp_tuple[0], '.')]] = bp_tuple[1]
        self.__write_breakpoints()
        
    def __write_breakpoints(self):
        try:
            f = open(self.env.get_breakpoints_file(), 'w')
            for bp_file, bp_list in self.bp_dict.items():
                for row in bp_list:
                    f.write('{0};{1:05d}\n'.format(bp_file, int(row)))
            f.close()
        except OSError:
            print('Could not write Breakpoints ...')
