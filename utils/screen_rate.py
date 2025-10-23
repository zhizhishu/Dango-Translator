import sys
from traceback import format_exc

IS_WINDOWS = sys.platform.startswith("win")

if IS_WINDOWS:
    from win32 import win32gui, win32print
    from win32.lib import win32con
    from win32.win32api import GetSystemMetrics
else:
    win32gui = win32print = win32con = None
    GetSystemMetrics = None


def getRealResolution():

    if IS_WINDOWS:
        hDC = win32gui.GetDC(0)
        # 横向分辨率
        w = win32print.GetDeviceCaps(hDC, win32con.DESKTOPHORZRES)
        # 纵向分辨率
        h = win32print.GetDeviceCaps(hDC, win32con.DESKTOPVERTRES)
        return w, h

    if sys.platform == "darwin":
        try:
            import Quartz

            display_id = Quartz.CGMainDisplayID()
            return Quartz.CGDisplayPixelsWide(display_id), Quartz.CGDisplayPixelsHigh(display_id)
        except Exception:
            pass

    return getScreenSize()


def getScreenSize():

    if IS_WINDOWS:
        w = GetSystemMetrics(0)
        h = GetSystemMetrics(1)
        return w, h

    if sys.platform == "darwin":
        try:
            import Quartz

            display_id = Quartz.CGMainDisplayID()
            bounds = Quartz.CGDisplayBounds(display_id)
            return int(bounds.size.width), int(bounds.size.height)
        except Exception:
            pass

    try:
        import tkinter

        root = tkinter.Tk()
        root.withdraw()
        size = (root.winfo_screenwidth(), root.winfo_screenheight())
        root.destroy()
        return size
    except Exception:
        return 0, 0


def getScreenRate(logger=None):

    try:
        real_resolution = getRealResolution()
        screen_size = getScreenSize()
        if screen_size[0] and screen_size[1]:
            screen_scale_rate = round(real_resolution[0] / screen_size[0], 2)
            if screen_scale_rate > 0:
                return screen_scale_rate
    except Exception:
        if logger:
            logger.error(format_exc())

    return 1.0
