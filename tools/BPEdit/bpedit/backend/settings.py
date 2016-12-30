from PyQt5.QtCore import QSettings
from PyQt5.QtWidgets import qApp
from pyqode.core.api import CodeEdit


class Settings:
    @property
    def highlight_whitespaces(self):
        return bool(int(self._qsettings.value('editor/highlight_whitespaces', '0')))
    
    @highlight_whitespaces.setter
    def highlight_whitespaces(self, value):
        self._qsettings.setValue('editor/highlight_whitespaces', int(value))
        
    @property
    def tab_width(self):
        return int(self._qsettings.value('editor/tab_width', '4'))

    @tab_width.setter
    def tab_width(self, value):
        self._qsettings.setValue('editor/tab_width', value)

    @property
    def font(self):
        return self._qsettings.value('editor/font', CodeEdit._DEFAULT_FONT)

    @font.setter
    def font(self, value):
        self._qsettings.setValue('editor/font', value)

    @property
    def color_scheme(self):
        default = 'qt' if qApp.palette().base().color().lightness() > 128 else 'darcula'
        return self._qsettings.value('editor/color_scheme', default)

    @color_scheme.setter
    def color_scheme(self, value):
        self._qsettings.setValue('editor/color_scheme', value)

    def __init__(self):
        self._qsettings = QSettings('GnuCOBOL-Contrib', 'BPEdit')
