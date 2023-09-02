# iwut_flutter

使用 Flutter 编写的新掌理 Android 端，2020-2021

-   原版为 flutter 2.5.2，现已适配 3.13.x
-   网络请求已经改为 mock，应用内时间 now 已经全部替换为 2021-08-30

生成 release

```bash
flutter build apk --split-per-abi
```

## iconfont 图标使用说明

下载压缩包后，放到`assets/iconfont`中，使用以下 python 代码生成`icon_font.dart`。

```python
import re
from pathlib import Path
import time
ROOT = Path(__file__).resolve().parent
MAIN = ROOT
# 生成的IconFont.dart 文件路径
IconDart = 'iwut_flutter/lib/config/icon_font.dart'
# iconfont css 文件存放路径
IconCss = 'iwut_flutter/assets/iconfont/iconfont.css'
# 将 iconfont 的 css 自动转换为 dart 代码


def translate():
    print('Begin translate...')

    code = """
        import 'package:flutter/widgets.dart';

        /// @author:  xxx
        /// @date: {date}
        /// @description  代码由程序自动生成。请不要对此文件做任何修改。

        class IconFont {

            static const String FONT_FAMILY = 'IconFont';

            {icon_codes}

        }
        """.strip()
    strings = []
    content = open(MAIN / IconCss).read().replace('\n  content', 'content')
    matchObj = re.finditer(r'.icon-(.*?):(.|\n)*?"\\(.*?)";', content)
    for match in matchObj:
        name = match.group(1)
        name = name.replace("-", "_")
        string = f'  static const IconData {name} = const IconData(0x{match.group(3)}, fontFamily: IconFont.FONT_FAMILY);'
        strings.append(string)
    strings = '\n'.join(strings)
    code = code.replace('{icon_codes}', strings)
    code = code.replace('{date}', time.strftime(
        "%Y-%m-%d %H:%M:%S", time.localtime()))
    open(MAIN / IconDart, 'w').write(code)
    print('Finish translate...')


if __name__ == "__main__":
    translate()

```
