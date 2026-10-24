# 复现环境

本次实际测试：Windows，R 4.6.0；核心包版本见reports/package_versions.csv，完整加载依赖和区域设置见reports/sessionInfo.txt。

分析流程不访问网络，直接读取安装的公开R数据包。config.R固定种子；1000次bootstrap用于教学复核。升级R/包后浮点或随机结果可能变化；先核对数据哈希、公式、种子与sessionInfo，再比较数值容差，不把所有差异当错误。当前仓库记录参考版本，并未宣称跨平台位级锁定。

Metafor相关二进制包提示由R4.6.1构建，本次在R4.6.0下实际加载、主流程与测试通过。若不能加载，请使用匹配版本或从CRAN重新安装，不能跳过分析后把旧报告当新结果。

数据变化检测使用从包导出的固定UTF-8/LF CSV及MD5，不用于密码学安全。原始数据导出路径data/raw被Git忽略；运行结果默认覆盖reports。练习请加--out=learning/output。

HTML指南由Markdown生成；修改指南后可用Python安装markdown并执行learning/render_guide.py重新渲染。这是可选文档工具，不是R分析依赖。
