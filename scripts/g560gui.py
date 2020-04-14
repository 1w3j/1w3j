#!/usr/bin/env python
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

## Main Window
from g560.gtk_interface.uimain import MainWindow

win = MainWindow()

## Runs window afer being built
win.show_all()
Gtk.main()
