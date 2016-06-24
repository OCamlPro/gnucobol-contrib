#-*- coding: utf-8 -*-

'''
Created on 03.03.2015

@author: pboehme
'''

import sys
from PyQt5.QtWidgets import QMainWindow, QApplication
from PyQt5.QtCore import QObject, QEvent, Qt

from Utils.LoadEnv import EnvLoader
from GUI.GuiHandler import GuiHandler

class BPEditEventFilter(QObject):
    gui_root = None
    
    def __init__(self, bpedit_window):
        super(BPEditEventFilter, self).__init__()
        self.gui_root = bpedit_window
    
    def eventFilter(self, receiver, event):
        if(event.type() == QEvent.KeyPress):
            if event.modifiers() == Qt.ControlModifier \
                and event.key() == Qt.Key_G:

                self.gui_root.gui.handle_strg_g()
                return True
            
            
        return super(BPEditEventFilter, self).eventFilter(receiver, event)    


class BPEditWindow(QMainWindow):
    env = None
    gui = None
    eventFilter = None
    
    def __init__(self):
        super(BPEditWindow, self).__init__()

        self.env = EnvLoader()
        self.env.initializePath()
        
        self.gui = GuiHandler(self.env)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = BPEditWindow()
    eventFilter = BPEditEventFilter(window)
    app.installEventFilter(eventFilter)
    
    sys.exit(app.exec_())
