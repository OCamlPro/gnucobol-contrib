#-*- coding: utf-8 -*-

'''
Created on 04.03.2015

@author: pboehme
'''

from os.path import join
from os import walk

from PyQt5 import uic
from PyQt5.QtCore import pyqtSlot, Qt
from PyQt5.QtGui import QColor
from PyQt5.QtWidgets import QComboBox, QTableWidget, QTableWidgetItem, \
                            QMessageBox, QPushButton, QLineEdit, QInputDialog

from Backend.BreakpointMgt import BPMgr 
from Backend.CWrapper import DebugModuleLoader

class GuiHandler:
    ui = None    
    srcCombo = None
    table = None
    breakpoints = None
    saveButton = None
    searchField = None
    searchButton = None
    
    def __init__(self, env_loader):
        self.env = env_loader
        self.initUI()

    
    def initUI(self):
        self.ui = uic.loadUi(self.env.getUIFile())
        
        # Find table widget and save reference
        self.table = self.ui.findChild(QTableWidget, name='tableWidget')
        
        # Find save button and save reference
        self.saveButton = self.ui.findChild(QPushButton, name='saveButton')
        
        # Find search field, search button and save reference
        self.searchField = self.ui.findChild(QLineEdit, name='searchField')
        self.searchButton = self.ui.findChild(QPushButton, name='searchButton')
                 
        # Load the source file names into the combobox
        self.srcCombo = self.ui.findChild(QComboBox, 'srcCombo')
        self.srcCombo.addItem('Quelle wählen')
        for dirpath, dirs, files in walk(self.env.getSrcFolder()):
            filteredList = [elem for elem in files if elem.endswith('.dll') or elem.endswith('.so')]
            self.srcCombo.addItems(filteredList)
        
        # Connect Slots with handle methods
        self.srcCombo.currentIndexChanged.connect(self.loadSrcFile)
        self.table.cellDoubleClicked.connect(self.setBP)
        self.saveButton.clicked.connect(self.saveBP)
        self.searchField.textChanged.connect(self.onSearchTextChanged)
        self.searchField.returnPressed.connect(self.onSearchButtonClicked)
        self.searchButton.clicked.connect(self.onSearchButtonClicked)
        
        self.ui.show()
    
    def loadSrcFile(self):
        filename = join(self.env.getSrcFolder(), self.srcCombo.currentText())

        modLoad = DebugModuleLoader(self.srcCombo.currentText())
        lineCount = modLoad.getModuleLineCount()
        
        for lineNr in range(lineCount):
            line = modLoad.getSrcLine(lineNr + 1)
            self.table.insertRow(lineNr)
            
            item = QTableWidgetItem(str('   '))
            item.setFlags(Qt.ItemIsSelectable | Qt.ItemIsEnabled)
            self.table.setItem(lineNr, 0, item)
            
            item = QTableWidgetItem(line)
            item.setFlags(Qt.ItemIsSelectable | Qt.ItemIsEnabled)
            self.table.setItem(lineNr, 1, item)
            if line.startswith('*'):
                self.table.item(lineNr, 1).setBackground(QColor(0xDD, 0xDD, 0xDD))
        
        # Load breakpoints file if neccesary
        if not self.breakpoints:
            self.breakpoints = BPMgr(self.env)
        
        bp_list = self.breakpoints.loadBreakpoints(filename)
        if bp_list: 
            for bp in bp_list:
                rowNr = int(bp) - 1
                self.table.item(rowNr, 0).setBackground(QColor(255, 0, 0))   
                
        # Lookup procedure division line so we don't accapt breakpoints before this line
        self.breakpoints.pd_line = 0
        for rowNr in range(0, self.table.rowCount()):
            lineText = self.table.item(rowNr, 1).text().lower()
            if('procedure' in lineText and 'division' in lineText and '.' in lineText):
                self.breakpoints.pd_line = rowNr
                break

    def setBP(self, row, col):
        if row > self.breakpoints.pd_line and not self.table.item(row, 1).text().startswith('*'):
            if self.table.item(row, 0).background().color() == QColor(255, 0, 0):
                self.table.item(row, 0).setBackground(QColor(255, 255, 255))
            else:
                self.table.item(row, 0).setBackground(QColor(255, 0, 0))
        
    def saveBP(self):
        setBPs = []
        for rowNr in range(self.table.rowCount()):
            if self.table.item(rowNr, 0).background().color() == QColor(255, 0, 0):
                setBPs.append(str(rowNr + 1))
        if self.breakpoints:
            self.breakpoints.saveBreakpoints((self.srcCombo.currentText(), setBPs))
        
    def onSearchTextChanged(self):
        searchText = self.searchField.text().lower()
        startRow = 0
        
        if self.table.currentRow() > 0 \
        and self.table.currentRow() < self.table.rowCount() - 1:
            startRow = self.table.currentRow()
        
        for rowNr in range(startRow, self.table.rowCount()):
            if(searchText in self.table.item(rowNr, 1).text().lower()):
                self.table.setCurrentCell(rowNr, 1)
                break

    def onSearchButtonClicked(self):
        searchText = self.searchField.text().lower()
        startRow = self.table.currentRow() + 1
        rowNr = 0
        for rowNr in range(startRow, self.table.rowCount()):
            if(searchText in self.table.item(rowNr, 1).text().lower()):
                self.table.setCurrentCell(rowNr, 1)
                break
        
        if rowNr == self.table.rowCount() - 1:
            msgBox = QMessageBox()
            msgBox.setWindowTitle("End of File")
            msgBox.setIcon(QMessageBox.Question)
            msgBox.setText("Suche von vorn beginnen?")
            msgBox.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
            msgBox.setDefaultButton(QMessageBox.Yes)
            ret = msgBox.exec()
            
            if ret == QMessageBox.Yes:
                self.table.setCurrentCell(0, 1)
                self.onSearchButtonClicked()
    
    def handle_strg_g(self):
        maxlines = self.table.rowCount()
        startline = 0
        if self.breakpoints:
            startline = self.breakpoints.pd_line + 1
        if maxlines > startline:
            linenumber_tuple = QInputDialog.getInt(self.ui, 'Gehe zu ...', 'Zeilennummer:', startline, startline, maxlines)
            if linenumber_tuple[1]:
                self.table.setCurrentCell(linenumber_tuple[0] - 1, 1)
