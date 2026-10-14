"""Writes the app icon for Android, iPhone and Windows from assets/icon/.

assets/icon/icon.svg is the drawing; icon.png (full icon), foreground.png and
background.png (Android adaptive icon layers) are 1024 px renders of it.
Run from the repository root after changing them: python3 tool/make_icons.py
"""
import json
from pathlib import Path

from PIL import Image, ImageDraw

src = Path('assets/icon')
icon = Image.open(src / 'icon.png').convert('RGB')
fg = Image.open(src / 'foreground.png').convert('RGBA')
bg = Image.open(src / 'background.png').convert('RGB')


def sized(image, px):
    return image.resize((px, px), Image.LANCZOS)


def rounded(image, radius=0.225):
    """The icon with rounded corners and a transparent outside."""
    out = image.convert('RGBA')
    mask = Image.new('L', out.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, out.width - 1, out.height - 1), int(out.width * radius), fill=255)
    out.putalpha(mask)
    return out


# Android: legacy icon for Android 7 and adaptive layers for Android 8+.
res = Path('android/app/src/main/res')
for density, legacy, layer in [('mdpi', 48, 108), ('hdpi', 72, 162), ('xhdpi', 96, 216),
                               ('xxhdpi', 144, 324), ('xxxhdpi', 192, 432)]:
    folder = res / f'mipmap-{density}'
    folder.mkdir(exist_ok=True)
    sized(rounded(icon), legacy).save(folder / 'ic_launcher.png')
    sized(fg, layer).save(folder / 'ic_launcher_foreground.png')
    sized(bg, layer).save(folder / 'ic_launcher_background.png')
anydpi = res / 'mipmap-anydpi-v26'
anydpi.mkdir(exist_ok=True)
(anydpi / 'ic_launcher.xml').write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n'
    '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
    '    <background android:drawable="@mipmap/ic_launcher_background"/>\n'
    '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
    '</adaptive-icon>\n')

# iPhone and iPad: square, no transparency; iOS rounds the corners itself.
appicon = Path('ios/Runner/Assets.xcassets/AppIcon.appiconset')
for entry in json.loads((appicon / 'Contents.json').read_text())['images']:
    points = float(entry['size'].split('x')[0])
    scale = int(entry['scale'][0])
    sized(icon, round(points * scale)).save(appicon / entry['filename'])

# Windows.
rounded(icon).save('windows/runner/resources/app_icon.ico',
                   sizes=[(s, s) for s in (16, 24, 32, 48, 64, 128, 256)])
