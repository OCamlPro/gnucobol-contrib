from os import walk
from os.path import join

from PyQt5 import uic
from PyQt5.QtWidgets import QComboBox, QDockWidget, QPushButton, QMenu, qApp
from pyqode.cobol.widgets import CobolCodeEdit
from pyqode.cobol.widgets import OutlineTreeWidget
from pyqode.cobol.widgets import PicOffsetsTable
from pyqode.core.api import ColorScheme

from bpedit.backend.cwrapper import DebugModuleLoader
from bpedit.backend.breakpoints_mgr import BreakpointsManager
from bpedit.gui.breakpoints_panel import BreakpointsPanel


class GuiHandler:
    def __init__(self, env_loader):
        self.env = env_loader
        self.__init_ui()

    def __init_ui(self):
        self.ui = uic.loadUi(self.env.get_ui_file())

        # Find controls and save references
        self.saveButton = self.ui.findChild(QPushButton, name='saveButton')
        self.codeEdit = self.ui.findChild(CobolCodeEdit, name='codeEdit')
        self.srcCombo = self.ui.findChild(QComboBox, name='srcCombo')
        self.searchMenu = self.ui.findChild(QMenu, name='searchMenu')
        self.searchMenu.addAction(self.codeEdit.search_panel.actionSearch)
        self.searchMenu.addAction(self.codeEdit.action_goto_line)

        outlineDock = self.ui.findChild(QDockWidget, name='outlineDock')
        outlineDock.setWindowTitle("Outline")
        offsetDock = self.ui.findChild(QDockWidget, name='offsetDock')
        offsetDock.setWindowTitle("Offset")

        self.__setup_code_editor()
        self.__load_src_files()
        self.__connect_slots()

        self.ui.show()

    def __connect_slots(self):
        self.srcCombo.currentIndexChanged.connect(self.__load_src_file)
        self.saveButton.clicked.connect(self.__save_breakpoints)

    def __load_src_files(self):
        self.srcCombo.addItem('Select source')
        for dirpath, dirs, files in walk(self.env.get_src_folder()):
            filteredList = [elem for elem in files if elem.endswith('.dll') or elem.endswith('.so')]
            self.srcCombo.addItems(filteredList)

    def __setup_code_editor(self):
        if qApp.palette().base().color().lightness() < 128:
            self.codeEdit.syntax_highlighter.color_scheme = ColorScheme('darcula')
        self.codeEdit.setReadOnly(True)
        self.codeEdit.read_only_panel.hide()
        self.codeEdit.global_checker_panel.hide()
        outlineTree = self.ui.findChild(OutlineTreeWidget, name='outlineTree')
        outlineTree.set_editor(self.codeEdit)
        offsetTable = self.ui.findChild(PicOffsetsTable, name='offsetTable')
        offsetTable.set_editor(self.codeEdit)
        offsetDock = self.ui.findChild(QDockWidget, name='offsetDock')
        offsetTable.show_requested.connect(offsetDock.show)
        offsetDock.hide()
        self.breakpointsPanel = self.codeEdit.panels.append(BreakpointsPanel())

    def __load_src_file(self):
        if self.srcCombo.currentIndex() <= 0:
            return
        filename = join(self.env.get_src_folder(), self.srcCombo.currentText())

        module_loader = DebugModuleLoader(self.srcCombo.currentText())
        line_count = module_loader.get_module_line_count()
        lines = []
        for lineNr in range(line_count):
            line = module_loader.get_src_line(lineNr + 1)
            text = line.lower()
            if 'procedure' in text and 'division' in text and '.' in text:
                self.breakpointsPanel.maxLine = lineNr
            lines.append(line)
        text = '\n'.join(lines)
        # todo need to add a setting for user to set encoding?
        self.codeEdit.setPlainText(text, 'text/x-cobol', 'latin-1')

        if not self.breakpoints:
            self.breakpoints = BreakpointsManager(self.env)
        self.breakpointsPanel.breakpoints = self.breakpoints.load_breakpoints(filename)

    def __save_breakpoints(self):
        if not self.breakpoints:
            self.breakpoints = BreakpointsManager(self.env)
        self.breakpoints.save_breakpoints((self.srcCombo.currentText(), self.breakpointsPanel.breakpoints))
