from os import walk
from os.path import join
from os.path import isfile
from sys import exit

from PyQt5 import uic
from PyQt5.QtGui import QColor
from PyQt5.QtWidgets import QActionGroup
from PyQt5.QtWidgets import QComboBox, QDockWidget, QPushButton, QMenu, QAction, QMainWindow, QInputDialog, QFontDialog, QMessageBox
from pyqode.cobol.widgets import CobolCodeEdit
from pyqode.cobol.widgets import OutlineTreeWidget
from pyqode.cobol.widgets import PicOffsetsTable
from pyqode.core.api import ColorScheme, PYGMENTS_STYLES

from bpedit.backend.cwrapper import DebugModuleLoader
from bpedit.backend.breakpoints_mgr import BreakpointsManager
from bpedit.backend.settings import Settings
from bpedit.gui.breakpoints_panel import BreakpointsPanel


class GuiHandler:
    def __init__(self, env_loader):
        self.breakpoints = None
        self.env = env_loader
        self.settings = Settings()
        self.__init_ui()

    def __init_ui(self):
        ui_file = self.env.get_ui_file()
        if isfile(ui_file) == False:
            errString = "The UI definition \"" + ui_file + "\" was not found.\x0a" \
                      + "You may change its path in settings.ini."
            print(errString)
            QMessageBox.critical(None, 'Starting BPEdit', errString)
            exit(1)
        self.ui = uic.loadUi(ui_file)

        # Find controls and save references
        self.main_window = self.ui.findChild(QMainWindow, name='MainWindow')
        self.reloadButton = self.ui.findChild(QPushButton, name='reloadButton')
        self.saveButton = self.ui.findChild(QPushButton, name='saveButton')
        self.codeEdit = self.ui.findChild(CobolCodeEdit, name='codeEdit')
        self.srcCombo = self.ui.findChild(QComboBox, name='srcCombo')
        self.searchMenu = self.ui.findChild(QMenu, name='searchMenu')
        self.searchMenu.addAction(self.codeEdit.search_panel.actionSearch)
        self.searchMenu.addAction(self.codeEdit.action_goto_line)

        # Options
        self.highlightWhitespacesAction = self.ui.findChild(QAction, name='highlightWhitespacesAction')
        self.highlightWhitespacesAction.setChecked(self.settings.highlight_whitespaces)
        self.setTabWidthAction = self.ui.findChild(QAction, name='setTabWidthAction')
        self.chooseEditorFontAction = self.ui.findChild(QAction, name='chooseEditorFontAction')
        self.colorSchemesMenu = self.ui.findChild(QMenu, name='colorSchemesMenu')
        self.colorSchemesActionGroup = QActionGroup(self.colorSchemesMenu)
        self.colorSchemesActionGroup.triggered.connect(self.__on_color_scheme_action_triggered)
        for style in PYGMENTS_STYLES:
            action = self.colorSchemesMenu.addAction(style)
            action.setCheckable(True)
            action.setChecked(action == self.settings.color_scheme)
            self.colorSchemesActionGroup.addAction(action)

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
        self.reloadButton.clicked.connect(self.__reload_source)
        self.saveButton.clicked.connect(self.__save_breakpoints)
        self.highlightWhitespacesAction.toggled.connect(self.__toggle_highlight_whitespaces)
        self.setTabWidthAction.triggered.connect(self.__set_tab_width)
        self.chooseEditorFontAction.triggered.connect(self.__choose_editor_font)

    def __load_src_files(self):
        self.srcCombo.clear()
        self.srcCombo.addItem('Select source')
        for dirpath, dirs, files in walk(self.env.get_src_folder()):
            filteredList = [elem for elem in files if elem.endswith('.dll') or elem.endswith('.so')]
            self.srcCombo.addItems(filteredList)

    def __setup_code_editor(self):
        self.codeEdit.syntax_highlighter.color_scheme = ColorScheme(self.settings.color_scheme)
        self.codeEdit.setReadOnly(True)
        self.codeEdit.read_only_panel.hide()
        self.codeEdit.global_checker_panel.hide()
        self.codeEdit.show_whitespaces = self.settings.highlight_whitespaces
        outlineTree = self.ui.findChild(OutlineTreeWidget, name='outlineTree')
        outlineTree.set_editor(self.codeEdit)
        offsetTable = self.ui.findChild(PicOffsetsTable, name='offsetTable')
        offsetTable.set_editor(self.codeEdit)
        offsetDock = self.ui.findChild(QDockWidget, name='offsetDock')
        offsetTable.show_requested.connect(offsetDock.show)
        offsetDock.hide()
        self.breakpointsPanel = self.codeEdit.panels.append(BreakpointsPanel())
        self.__update_breakpoints_background_color()

    def __load_src_file(self):
        # ComboBox is cleared
        if self.srcCombo.currentIndex() <= 0:
            return
        filename = join(self.env.get_src_folder(), self.srcCombo.currentText())

        module_loader = DebugModuleLoader(self.srcCombo.currentText())
        if module_loader.is_loaded() == False:
            QMessageBox.critical(
            self.main_window, 'Loading Module', "The module \"" + self.srcCombo.currentText() + "\" could not be loaded.")
            del module_loader
            return
        line_count = module_loader.get_module_line_count()
        if line_count is None:
            QMessageBox.critical(
            self.main_window, 'Loading Module', "The module \"" + self.srcCombo.currentText() + "\" doesn't provide debugging symbols.")
            del module_loader
            return
        
        lines = []
        for lineNr in range(line_count):
            line = module_loader.get_src_line(lineNr + 1)
            text = line.lower()
            if 'procedure' in text and 'division' in text and '.' in text:
                self.breakpointsPanel.maxLine = lineNr
            lines.append(line)
        text = '\n'.join(lines)
        del module_loader
        # todo need to add a setting for user to set encoding?
        self.codeEdit.setPlainText(text, 'text/x-cobol', 'latin-1')

        if not self.breakpoints:
            self.breakpoints = BreakpointsManager(self.env)
        self.breakpointsPanel.breakpoints = self.breakpoints.load_breakpoints(filename)

    def __reload_source(self):
        if self.srcCombo.currentIndex() == 0:
            self.__load_src_files()
        self.__load_src_file()

    def __save_breakpoints(self):
        if not self.breakpoints:
            self.breakpoints = BreakpointsManager(self.env)
        self.breakpoints.save_breakpoints((self.srcCombo.currentText(), self.breakpointsPanel.breakpoints))

    def __toggle_highlight_whitespaces(self, enable):
        self.settings.highlight_whitespaces = enable
        self.codeEdit.show_whitespaces = self.settings.highlight_whitespaces

    def __set_tab_width(self):
        tab_width, accepted = QInputDialog.getInt(
            self.main_window, 'Select tab width', "Tab width", self.settings.tab_width, 2)
        if accepted:
            self.settings.tab_width = tab_width
            self.codeEdit.tab_length = tab_width

    def __choose_editor_font(self):
        font, accepted = QFontDialog.getFont(self.codeEdit.font())
        if accepted:
            font_name = font.family()
            self.settings.font = font_name
            self.codeEdit.font_name = font_name

    def __on_color_scheme_action_triggered(self, action):
        color_scheme = action.text().replace('&', '')
        self.settings.color_scheme = color_scheme
        self.codeEdit.syntax_highlighter.color_scheme = color_scheme
        self.__update_breakpoints_background_color()

    def __update_breakpoints_background_color(self):
        editor_background = ColorScheme(self.settings.color_scheme).background
        if editor_background.lightness() < 128:
            self.breakpointsPanel.background = QColor('#3A2323')
        else:
            self.breakpointsPanel.background = QColor('#FFC8C8')
        self.breakpointsPanel.update_markers()