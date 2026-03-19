# 柱状图 Y 轴刻度规则（与金医圣小程序一致）

## 小程序实现位置

- **页面**: `mini-jys/src/modules/jintiku/pages/userInfo/report.vue`
- **图表组件**: `qiun-data-charts`，类型 `type="column"`
- **配置**: `opts.yAxis.data: [{ min: 0 }]`（只设 min，不设 max）
- **底层库**: `u-charts`（`mini-jys/src/components/u-charts/u-charts.js`）

## 小程序 Y 轴取值规则（uCharts）

### 1. 数据范围

- `minData` = 当前系列数据中的最小值  
- `maxData` = 当前系列数据中的最大值  
- 若 `minData === maxData`：  
  - 若为 0 → `maxData` 置为 10  
  - 否则 → `minData` 置为 0  

### 2. 根据数值范围选「步长基数」limit（getDataRange）

`range = maxData - minData`，按区间取整的步长基数：

| range 条件       | limit   |
|------------------|---------|
| ≥ 10000          | 1000    |
| ≥ 1000           | 100     |
| ≥ 100            | 10      |
| ≥ 10             | 5       |
| ≥ 1              | 1       |
| ≥ 0.1            | 0.1     |
| ≥ 0.01           | 0.01    |
| ≥ 0.001          | 0.001   |
| …更小             | 0.0001 / 0.00001 / 0.000001 |

### 3. 上下界圆整（findRange）

- **minRange** = `findRange(minData, 'lower', limit)`：向下圆整到 limit 的整数倍  
- **maxRange** = `findRange(maxData, 'upper', limit)`：向上圆整到 limit 的整数倍  

实现要点：  
- 先把数按 limit 放大成整数再 `Math.floor` / `Math.ceil`，再除回倍数，得到「好看」的 min/max。

### 4. 刻度数量与等分

- **splitNumber** 默认 **5**（`u-charts.js` 第 7014 行 `opts.yAxis.splitNumber: 5`）  
- 刻度数 = splitNumber + 1 = **6 个点**  
- **等间隔**: `eachRange = (maxRange - minRange) / 5`  
- 刻度值: `minRange`, `minRange + eachRange`, … , `maxRange`（再按绘制顺序 reverse）

### 5. 小结

- 小程序 Y 轴：**先按数据范围选 limit → 用 findRange 得到 minRange/maxRange → 再按 splitNumber=5 等分**，因此是**等间隔**的 6 个刻度。  
- 报告页只配置了 `yAxis.data: [{ min: 0 }]`，max 和刻度间隔全部由 uCharts 按上述规则自动计算。

## Flutter 侧对齐方式

在 `column_chart_widget.dart` 中已按同一逻辑实现：

- 使用相同的 `getDataRange`（按 range 选 limit）和 `findRange`（上下界圆整）得到 `minRange`、`maxRange`。  
- `splitNumber = 5`，Y 轴 6 个刻度，等间隔。  
- 这样 Flutter 与小程序在「Y 轴数字线怎么取值」上保持一致。
