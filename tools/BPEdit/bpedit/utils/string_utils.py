import os


def find_last_occur(f, c):
    f_basename = os.path.basename(f)
    
    pos = f_basename.find(c, 0)
    lastpos = pos
    while pos >= 0:
        lastpos = pos
        pos = f_basename.find(c, lastpos + 1)
         
    return lastpos
