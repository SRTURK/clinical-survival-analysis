"""Render the editable Markdown tutorial as a self-contained reading page."""
from pathlib import Path
import html
import markdown

ROOT = Path(__file__).resolve().parents[1]
source = (ROOT / '项目重做指南.md').read_text(encoding='utf-8')
title = source.splitlines()[0].lstrip('# ')
document = markdown.Markdown(extensions=['tables', 'fenced_code', 'toc'],
                            extension_configs={'toc': {'toc_depth': '2-3'}})
body = document.convert(source)
css = '''
*{box-sizing:border-box}html{scroll-behavior:smooth}
body{margin:0;background:#f3f6f8;color:#243746;font:16px/1.85 "Microsoft YaHei",system-ui,sans-serif}
.layout{max-width:1480px;margin:auto;display:grid;grid-template-columns:275px minmax(0,1fr);gap:30px;padding:32px}
nav{position:sticky;top:24px;align-self:start;max-height:calc(100vh - 48px);overflow:auto;font-size:13px;padding:18px 12px}
nav strong{font-size:16px}nav ul{list-style:none;padding-left:14px}nav>div>ul{padding-left:0}nav li{margin:6px 0}
a{color:#176b87;text-decoration:none}a:hover{text-decoration:underline}
main{min-width:0;background:#fff;border-top:6px solid #176b87;padding:40px 48px;border-radius:4px}
h1{font-size:30px;line-height:1.5;margin:0 0 24px}h2{font-size:24px;color:#176b87;margin:44px 0 18px;padding-bottom:10px;border-bottom:1px solid #dce6eb}
h3{font-size:19px;margin-top:30px}h2,h3{scroll-margin-top:20px}
p,li{overflow-wrap:anywhere}pre{overflow:auto;background:#eef3f6;border:1px solid #dde7ed;border-radius:6px;padding:18px;line-height:1.65;font-size:13px}
code{font-family:Consolas,"Microsoft YaHei",monospace;background:#eef3f6;padding:2px 4px;border-radius:3px}pre code{padding:0;background:none}
table{display:block;width:100%;overflow:auto;border-collapse:collapse;font-size:14px;margin:22px 0}th,td{text-align:left;border-bottom:1px solid #dce6eb;padding:10px 12px;min-width:120px}th{background:#edf5f8}td code{white-space:nowrap}
blockquote{margin:20px 0;padding:6px 20px;border-left:4px solid #176b87;background:#edf5f8}img{max-width:100%}
.toplink{display:block;margin:0 0 20px;font-size:13px;color:#617785}
@media(max-width:1000px){.layout{display:block;padding:16px}nav{position:static;max-height:300px;margin-bottom:20px}main{padding:28px 22px}h1{font-size:25px}}
@media print{nav,.toplink{display:none}.layout{display:block;padding:0}body{background:white}main{padding:0;border:0}pre{white-space:pre-wrap;overflow-wrap:anywhere}h2,h3{break-after:avoid}}
'''
page = f'''<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(title)}</title><style>{css}</style></head>
<body><div class="layout"><nav aria-label="指南目录"><strong>学习路线</strong>{document.toc}</nav>
<main><a class="toplink" href="项目重做指南.md">可编辑 Markdown 原稿</a>{body}</main></div></body></html>'''
(ROOT / '项目重做指南.html').write_text(page, encoding='utf-8')
print('Rendered:', ROOT / '项目重做指南.html')
