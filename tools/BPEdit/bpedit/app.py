import os
import sys

from PyQt5.QtWidgets import QMainWindow, QApplication

from bpedit import __version__
from bpedit.gui.gui_handler import GuiHandler
from bpedit.utils.load_env import EnvLoader


class BPEditWindow(QMainWindow):
    env = None
    gui = None
    eventFilter = None

    def __init__(self):
        super(BPEditWindow, self).__init__()
        self.env = EnvLoader()
        self.env.init_path()
        self.gui = GuiHandler(self.env)


class BPEditApplication:
    def __init__(self):
        print("BPEdit v%s" % __version__)
        os.environ['QT_LOGGING_TO_CONSOLE'] = '1'
        self.app = QApplication(sys.argv)
        self.window = BPEditWindow()

    def run(self):
        return self.app.exec_()


def main():
    app = BPEditApplication()
    sys.exit(app.run())
