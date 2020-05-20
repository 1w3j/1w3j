#!/usr/bin/env python
import gi
gi.require_version('Gtk', '3.0')
import json
import os
from gi.repository import Gtk, Gdk
import rpyc


class ListBoxRowWithData(Gtk.ListBoxRow):
    def __init__(self, data):
        Gtk.ListBoxRow.__init__(self)
        self.data = data
        self.add(Gtk.Label(data))


class UiBoxes:
    def __init__(self):
        self.ui_buttons = UiButtons()
        self.ui_widget = WidgetHelpers()

    def home_box(self):
        # Main "Box" to build over window
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        hbox.pack_end(vbox, True, True, 10)

        color_list_box = self.color_list_box('current')

        vbox.pack_start(color_list_box, False, False, 10)

        # Creates 'Box' to handle button widgets
        btn_box = Gtk.Box(spacing=6)
        vbox.pack_end(btn_box, False, True, 0)  # Packs box to end of 'vbox'

        btn_close = self.ui_buttons.create_btn_close_apply()
        btn_box.pack_end(btn_close, False, False, 0)

        return hbox

    def fake_box(self):
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=2)
        return hbox

    def color_list_box(self, profile):
        main_options = ['primary', 'secondary', ]
        led_options = ['right_primary', 'left_primary',
                       'right_secondary', 'left_secondary']
        box_fill = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)

        listbox = Gtk.ListBox()
        box_fill.pack_start(listbox, True, False, 0)

        for option in led_options:
            button = self.ui_buttons.create_btn_color_select(option, profile)

            if '_' in option:
                option = option.replace('_', ' ')

            row = self.ui_widget.create_list_row(
                f"{option.title()} LED", button)

            listbox.add(row)

        def sort_func(row_1, row_2, data, notify_destroy):
            return row_1.data.lower() > row_2.data.lower()

        def filter_func(row, data, notify_destroy):
            return False if row.data == 'Fail' else True

        def on_row_activated(listbox_widget, row):
            print(row.data)

        return box_fill


class UiButtons:
    def __init__(self):
        self.btn_color_sel = Gtk.ColorButton()
        self.led_control = LedControls()
        self.led_options = {}

    def create_btn_color_select(self, option, profile='default'):
        led_color = WidgetHelpers.get_led_profile(profile)

        self.led_options[option] = led_color[option]
        hbox = Gtk.ButtonBox(orientation=Gtk.Orientation.HORIZONTAL, spacing=2)

        # Color Selection Button
        # Converts HEX color to RGB
        rgb = tuple(float(int(self.led_options[option][i:i + 6 // 3], 16) / 255)
                    for i in range(0, 6, 6 // 3))

        color = Gdk.RGBA(rgb[0], rgb[1], rgb[2])

        self.btn_color_sel.set_rgba(color)
        self.btn_color_sel.connect(
            "color-set", self.on_color_selector_click, option)

        hbox.pack_start(self.btn_color_sel, False, False, 2)

        return hbox

    def create_btn_close_apply(self):
        hbox = Gtk.ButtonBox(orientation=Gtk.Orientation.HORIZONTAL)

        # Apply selected color
        btn_apply = Gtk.Button(label="Apply")
        btn_apply.connect("clicked", self.on_apply_click)
        hbox.pack_end(btn_apply, False, False, 0)

        # Closes application
        btn_close = Gtk.Button(label="Close")
        btn_close.connect("clicked", Gtk.main_quit)
        hbox.pack_start(btn_close, False, False, 0)

        return hbox

    def on_color_selector_click(self, widget, option):
        color = widget.get_rgba()

        red = int(color.red * 255)
        green = int(color.green * 255)
        blue = int(color.blue * 255)

        self.led_options[option] = "{:02x}{:02x}{:02x}".format(
            red, green, blue)

    def on_apply_click(self, widget):
        if len(self.led_options) > 0:
            for option, color in self.led_options.items():
                self.led_control.set_color(option, color)
            WidgetHelpers.put_led_profile('current', self.led_options)


class WidgetHelpers:
    @staticmethod
    def get_led_profile(profile):
        try:
            with open(os.environ['HOME']+'/.config/g560/profilesettings.json') as profiles:
                loaded_profile = json.load(profiles)
                loaded_profile = loaded_profile['profiles'][profile]

                return loaded_profile

        except Exception as e:
            print("Error loading JSON: ", e)

    def put_led_profile(profile, data):
        try:
            with open(os.environ['HOME']+'/.config/g560/profilesettings.json', 'r+') as profiles:
                loaded_profile = json.load(profiles)
                loaded_profile['profiles'][profile] = data

                profiles.seek(0)
                json.dump(loaded_profile, profiles, indent=4)

        except Exception as e:
            print("Error loading JSON: ", e)

    @staticmethod
    def create_list_row(text, button):
        row = Gtk.ListBoxRow()
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=50)
        row.add(hbox)

        label = Gtk.Label(text, xalign=0)
        hbox.pack_start(label, True, True, 0)

        hbox.pack_start(button, False, True, 0)

        return row

    @staticmethod
    def create_label(text):
        hbox_text = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)

        label = Gtk.Label()
        label.set_text(text)
        hbox_text.pack_start(label, False, False, 0)

        return hbox_text


class ValueCheck:
    def led_option(led_option):
        raise ValueError(f"Invalid Option: ['{led_option}']")

    # Needs to raise error if index not met
    def check_color(color):
        color_int = int(color, 16)
        color_max = 16777215

        if color_int < 0 or color_int > color_max:
            raise ValueError(f"Invalid Color Option: #{color}")

        return color

    def cycle_speed(speed):
        if speed >= 0 and speed <= 10:
            hex_speed = "0x{:02x}".format(255 - int(speed * 25.5))[2:]
        else:
            raise ValueError(
                "Error: Speed value does not meet requirements '0 - 10'")

        return str(hex_speed)

    def breathe_speed(speed):
        if speed >= 5 and speed <= 10:
            hex_speed = "0x{:02x}".format(16 - int(speed))[2:]
        elif speed >= 0 and speed < 5:
            hex_speed = "0x{:02x}".format(24 - int(speed))[2:]
        else:
            raise ValueError(
                "Error: Speed value does not meet requirements '0 - 10'")

        return str(hex_speed)

    def brightness(brightness):
        if brightness >= 0 and brightness <= 100:
            hex_brightness = "0x{:02x}".format(int(brightness * 2.559))[2:]
        else:
            raise ValueError(
                "ERROR: Brightness value does not meet requirements 0 - 100")

        return str(hex_brightness)


class LedControls(object):
    """
    Controls for G560 LEDs
    """

    def __init__(self):
        # UsbOperations.__init__(self)
        self.led_id = {'left_secondary': '00', 'right_secondary': '01',
                       'left_primary': '02', 'right_primary': '03'}
        self.conn = rpyc.connect("localhost", port=17657)

    def build_option_list(self, led_option):
        """
        Builds list of leds based on value of of 'led_option'
        Options:
        'all': Selects all LEDs
        'primary': Selects both primary LEDs
        'secondary': Selects both secondary LEDs
        'left': Selects both left speaker LEDs
        'right': Selects both right speaker LEDs
        """

        if led_option == 'all':
            led_list = self.led_id
        else:
            led_list = [key for key in self.led_id.keys()
                        if led_option.lower() in key]

        if len(led_list) == 0:
            ValueCheck.led_option(led_option)

        return led_list

    def set_color(self, led_option, color):
        control_data = '11ff043a{}01{}02'

        ValueCheck.check_color(color)

        if led_option not in self.led_id:
            led_list = self.build_option_list(led_option)

            data = [control_data.format(
                self.led_id[led], color) for led in led_list]
        else:
            data = [control_data.format(self.led_id[led_option], color)]

        self.conn.root.data_transfer(data)

    def set_off(self, led_option):
        self.set_color(led_option, '000000')

    def set_color_cycle(self, led_option, speed=8, brightness=75):
        control_data = '11ff043e{}020000000000{}f8{}'

        speed = ValueCheck.cycle_speed(speed)
        brightness = ValueCheck.brightness(brightness)

        if led_option not in self.led_id:
            led_list = self.build_option_list(led_option)

            data = [control_data.format(
                self.led_id[led], speed, brightness) for led in led_list]
        else:
            data = [control_data.format(
                self.led_id[led_option], speed, brightness)]

        self.conn.root.data_transfer(data)

    def set_breathe(self, led_option, color, speed=5, brightness=100):
        control_data = '11ff043e{}04{}{}f000{}'

        color = ValueCheck.check_color(color)
        speed = ValueCheck.breathe_speed(speed)
        brightness = ValueCheck.brightness(brightness)

        if led_option not in self.led_id:
            led_list = self.build_option_list(led_option)
            data = [control_data.format(
                self.led_id[led], color, speed, brightness) for led in led_list]
        else:
            data = [control_data.format(
                self.led_id[led_option], color, speed, brightness)]
            print(data)

        self.conn.root.data_transfer(data)


class MainWindow(Gtk.ApplicationWindow):
    def __init__(self):
        # Inherits Gtk.Window
        Gtk.Window.__init__(self, title="Logitech LED Controls")
        self.set_default_size(640, 380)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_border_width(2)
        self.connect("destroy", Gtk.main_quit)

        # Helper classes
        self.uiboxes = UiBoxes()

        # Builds sidebar stack for main window
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        sidebar = self.create_sidebar()
        hbox.pack_end(sidebar, True, True, 1)

        self.add(hbox)

    def create_sidebar(self):
        vbox = Gtk.Box(homogeneous=False,
                       orientation=Gtk.Orientation.HORIZONTAL, spacing=2)

        stack = Gtk.Stack()
        stack.set_hhomogeneous(True)

        stack.add_titled(self.uiboxes.home_box(), "Home", "Home")
        # stack.add_titled(self.uiboxes.fake_box(),
        #                  "Color Profiles", "Color Profiles")
        # stack.add_titled(self.uiboxes.fake_box(),
        #                  "Alert Profiles", "Alert Profiles")
        # stack.add_titled(self.uiboxes.fake_box(), "label", "A label")

        stack_sidebar = Gtk.StackSidebar()
        stack_sidebar.set_stack(stack)
        stack_sidebar.set_size_request((640 / 5), 300)

        vbox.pack_start(stack_sidebar, False, True, 0)
        vbox.pack_start(stack, True, True, 0)

        return vbox


win = MainWindow()

# Runs window afer being built
win.show_all()
Gtk.main()
