# Common Region Picker - 省市区选择组件

## ADDED Requirements

### Requirement: 弹出选择弹窗
系统 SHALL 提供点击input弹出省市区选择弹窗。

#### Scenario: 弹出弹窗
- **WHEN** 用户点击省市区输入框
- **THEN** 弹出标题为"选择省/市/县"的ElDialog弹窗

### Requirement: Tab切换加载数据
系统 SHALL 通过省/市/县三个Tab切换，分别加载对应级别的数据。

#### Scenario: 切换到省Tab
- **WHEN** 用户点击"省"Tab
- **THEN** 右侧加载并显示所有省份列表

#### Scenario: 切换到市Tab
- **WHEN** 用户点击"市"Tab
- **THEN** 右侧加载并显示已选省份下的城市列表

#### Scenario: 切换到县Tab
- **WHEN** 用户点击"县"Tab
- **THEN** 右侧加载并显示已选城市下的区县列表

### Requirement: 选择并展示
系统 SHALL 支持点击选项选中，并在底部显示已选择路径。

#### Scenario: 选中省份
- **WHEN** 用户在省份列表中点击某个省份
- **THEN** 底部显示该省份名称，自动切换到"市"Tab

#### Scenario: 选中城市
- **WHEN** 用户在城市列表中点击某个城市
- **THEN** 底部路径更新为"XX省/XX市"，自动切换到"县"Tab

#### Scenario: 选中区县
- **WHEN** 用户在区县列表中点击某个区县
- **THEN** 底部路径更新为"XX省/XX市/XX区"

### Requirement: 确认选择
系统 SHALL 支持点击确定按钮确认选择，点击取消按钮关闭弹窗。

#### Scenario: 确认选择
- **WHEN** 用户选择完成后点击"确定"按钮
- **THEN** 弹窗关闭，input显示完整路径（如"山东省/青岛市/黄岛区"）

#### Scenario: 取消选择
- **WHEN** 用户点击"取消"按钮
- **THEN** 弹窗关闭，选择结果不更新

### Requirement: 支持清空操作
系统 SHALL 支持清空已选择的省市区数据。

#### Scenario: 清空选择
- **WHEN** 用户点击清空按钮
- **THEN** 底部路径清空，组件值变为空

### Requirement: 支持编辑回显
系统 SHALL 支持在编辑场景下回显已选择的省市区数据。

#### Scenario: 编辑时回显
- **WHEN** 组件接收到已存在的省市区数据（包含code和name）
- **THEN** 弹窗打开时自动定位到对应的Tab并显示已选中的项

### Requirement: 支持选择级别配置
系统 SHALL 支持配置选择级别（省市/省市区）。

#### Scenario: 配置为省市级别
- **WHEN** 组件设置 level=2
- **THEN** 只显示"省"和"市"两个Tab，选择完成后显示"XX省/XX市"

#### Scenario: 配置为省市区级别
- **WHEN** 组件设置 level=3（默认值）
- **THEN** 显示省、市、县三个Tab，选择完成后显示"XX省/XX市/XX区"
