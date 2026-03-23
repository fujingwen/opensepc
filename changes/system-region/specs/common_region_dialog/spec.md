# Common Region Dialog - 省市区选择组件（Dialog形式）

## ADDED Requirements

### Requirement: 弹出选择Dialog
系统 SHALL 提供点击按钮弹出省市区选择Dialog。

#### Scenario: 弹出Dialog
- **WHEN** 用户点击省市区选择按钮
- **THEN** 弹出标题为"省市区"的ElDialog弹窗

### Requirement: 树形结构展示
系统 SHALL 使用树形结构展示行政区划数据，支持懒加载展开子节点。

#### Scenario: 展开节点
- **WHEN** 用户点击节点前的展开箭头
- **THEN** 加载并显示该节点的子节点

### Requirement: 选择并展示
系统 SHALL 支持点击节点选中，并在右侧显示已选择路径。

#### Scenario: 选中节点
- **WHEN** 用户在左侧树形列表中点击某个节点
- **THEN** 右侧显示该节点的完整路径（如"北京市/市辖区/东城区"）

### Requirement: 确认选择
系统 SHALL 支持点击确定按钮确认选择，点击取消按钮关闭弹窗。

#### Scenario: 确认选择
- **WHEN** 用户选择完成后点击"确定"按钮
- **THEN** 弹窗关闭，返回选中的行政区划信息

#### Scenario: 取消选择
- **WHEN** 用户点击"取消"按钮
- **THEN** 弹窗关闭，选择结果不更新

### Requirement: 支持清空操作
系统 SHALL 支持清空已选择的省市区数据。

#### Scenario: 清空选择
- **WHEN** 用户点击"清空列表"按钮
- **THEN** 右侧已选路径清空

### Requirement: 支持编辑回显
系统 SHALL 支持在编辑场景下回显已选择的省市区数据。

#### Scenario: 编辑时回显
- **WHEN** 组件接收到已存在的省市区数据（包含code和name）
- **THEN** 弹窗打开时自动定位到对应的节点并选中

### Requirement: 支持选择级别配置
系统 SHALL 支持配置选择级别（省市/省市区）。

#### Scenario: 配置为省市级别
- **WHEN** 组件设置 level=2
- **THEN** 只允许选择到市级别

#### Scenario: 配置为省市区级别
- **WHEN** 组件设置 level=3（默认值）
- **THEN** 允许选择到区县级别