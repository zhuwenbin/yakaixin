# 首页-刷题页面对齐指南（brushing.vue → lib/features/home/views/home_page.dart）

目标：让 Flutter 版首页-刷题与小程序保持 1:1 视觉与交互一致，消除当前出现的溢出、间距不一致、字号偏大的问题。

## 1. 当前差距（结合截图）
- 价格区域溢出：秒杀卡右侧出现 “overflowed by 19 pixels” 警告，原因是价格行未做收缩/基线对齐。
- 字号与间距偏大：标题、价格字号普遍大于小程序，且上下留白不一致，导致信息密度过低。
- 倒计时布局松散：背景条高度、内边距和文字位置偏移，显得漂浮。
- Tab 缺失：小程序有 “题库/网课/直播”，Flutter 仅保留 “题库”。
- 列表卡片留白过多：卡片 padding、行高、阴影深度与小程序不同，整体显得更肥厚。

## 2. 视觉规格速查（小程序标注 → Flutter 数值）
- 页面左右留白：24.w；模块顶部间距：32.h。
- Header（专业选择区）：高度 96.h，字号 32.sp，fontWeight.w600，箭头 20.w；顶部安全区使用 SafeArea。
- “秒杀”标题：字号 32.sp，字重 w600，图标 30.w。
- 秒杀卡（examination-test-item seckill 模式）
  - 容器：圆角 32.r，最小高度 213.h，左右内边距 32.w，上 24.h，下 0。
  - 渐变：#FBF1FF → #D8F0FF，阴影 rgba(27,38,55,0.06)，blur 30.r。
  - 标题：34.sp、w500、行高 1.4，最多 2 行省略。
  - 原价：32.sp、w800、#A3A3A3，删除线；标签图 70.w × 30.h。
  - 秒杀价：符号 24.sp、w500、#D845A6；金额 40.sp、w800、#D845A6；整行基线对齐。
  - 标签区：左右间距 16.w，文字 20.sp；题数标签背景 #FFD27C，圆角 8.r；有效期描边 #4981D7，3.w。
  - 倒计时底条：宽约 400.w，高 94.h，顶部内边距 22.h；文字 28.sp、字重 400/600，颜色 #082980，字间距 6.w。
- 普通商品卡
  - 卡片：背景 #F4F9FF，圆角 32.r，阴影同上，外边距底 24.h，内边距 32.w、24.h、32.w、0。
  - 标题：34.sp、w500、行高 1.4，最多 2 行。
  - 价格：原价 28.sp 删除线 #A3A3A3；现价符号 24.sp，金额 32.sp，颜色 #FF5E00，基线对齐。
  - 标签：背景 #EBF1FF，文字 20.sp、#2E68FF，圆角 8.r；有效期描边 #4981D7（3.w）。
  - 底部按钮：高度 100.h，按钮 160.w × 56.h，圆角 64.r，背景 #2E68FF，字号 28.sp。

## 3. Flutter 修改清单（lib/features/home/views/home_page.dart）
1) 头部与 SafeArea  
   - 用 `SafeArea(top: true, bottom: false)` 包裹整体或头部，移除额外的占位高度（目前叠加了 `MediaQuery.padding.top + 96.h + 79.h`，导致白边过多）。  
   - `_buildFixedHeader` 中将字号改为 32.sp / w600，箭头大小 20.w，左右 padding 24.w。

2) PageView 宽度与圆角  
   - 在 `_buildSeckillBanner` 外层增加 `ClipRRect(borderRadius: BorderRadius.circular(32.r))` 以避免图片外溢。  
   - 为 `PageView.builder` 设置 `padEnds: false` 并使用 `PageController(viewportFraction: 0.92)`（或左右 24.w padding + `NeverScrollableScrollPhysics` 视需求）保持与小程序相同的边缘露出比例。

3) 价格行防溢出  
   - 在 `_buildSeckillCard` 的价格 Row 外包 `Flexible` 或 `ConstrainedBox`，并将价格 Row 的 `mainAxisSize` 设为 `MainAxisSize.min`，`textBaseline: TextBaseline.alphabetic`。  
   - 原价 + 标签用 `Flexible` 包裹，必要时 `FittedBox(fit: BoxFit.scaleDown)`，避免大数字 + 标签叠加导致 overflow。

4) 倒计时区域  
   - 将宽度设为 `min(MediaQuery.of(context).size.width * 0.7, 400.w)`，并用 `FittedBox(fit: BoxFit.scaleDown)` 包裹整行文字，确保不同机型不溢出。  
   - 使用实际倒计时组件后，给数字增加 `letterSpacing: 2.w`，字号 28.sp，颜色 #082980。

5) Tab 栏  
   - 根据 `PUBLISH` 配置还原 “题库/网课/直播” 三个 Tab，激活态字号 36.sp、非激活 32.sp，下划线宽 80.w、高 8.h、圆角 4.r，颜色 #018BFF。  
   - 将 Tab 状态与列表数据联动（目前仅静态 “题库”）。

6) 列表卡片压缩留白  
   - 将普通卡的顶部 padding 从 24.h 调整为 20.h，底部 0 → 12.h，与小程序一致。  
   - 将卡片阴影 `spreadRadius` 设为 0，`blurRadius` 30.r，颜色 `Color(0x0F1B2637)`，避免阴影过重。  
   - 调整标题字号至 32.sp-34.sp 区间，价格保持 24.sp/32.sp，标签字号 20.sp。

7) 其他细节  
   - 图片使用 `CachedNetworkImage`（带占位与 errorBuilder），避免加载闪烁。  
   - 将按钮、标签、价格颜色统一放到 `AppColors`，防止多个 Hex 写死后出现偏差。  
   - 所有数字展示使用 `toStringAsFixed(2)` 控制小数位，避免 “0.00” 被截断。

## 4. 验证步骤
- 对照小程序截图检查：字号、行高、间距、颜色、阴影、圆角。  
- 运行 Flutter 真机/模拟器，确保无 overflow 黄条；尤其关注：价格行、倒计时区域、长标题两行省略。  
- 切换不同机型分辨率（使用 ScreenUtil），确认 seckill 卡和列表卡高度自适应。  
- Tab 切换、下拉刷新、点击秒杀卡/列表卡跳转逻辑与小程序一致。

执行完上述清单，Flutter 页面会与小程序在视觉和交互上保持一致，并消除当前的溢出和布局松散问题。
