# Backend Development Specification

## ADDED Requirements

### Requirement: RESTful API规范

系统 SHALL 遵循RESTful API设计规范。

#### Scenario: 使用正确的HTTP方法

- **WHEN** 设计API接口
- **THEN** 应使用正确的HTTP方法：
  - `GET`: 查询（`/list`, `/{id}`）
  - `POST`: 新增（`/`）
  - `PUT`: 修改（`/`）
  - `DELETE`: 删除（`/{ids}`）

#### Scenario: URL命名使用kebab-case

- **WHEN** 设计API路径
- **THEN** 应使用kebab-case（小写字母和连字符），如 `/demo/demo/list`, `/auth/login`

### Requirement: 统一响应格式

系统 SHALL 所有API必须返回统一包装类 `R<T>`。

#### Scenario: 成功响应

- **WHEN** API执行成功
- **THEN** 应返回 `R.success(data)`，其中 `data` 为实际数据

#### Scenario: 失败响应

- **WHEN** API执行失败
- **THEN** 应返回 `R.fail(message)`，其中 `message` 为错误信息

#### Scenario: 禁止直接返回实体或Map

- **WHEN** 在Controller层返回数据
- **THEN** 必须转换为 VO 对象并使用 `R<T>` 包装，禁止直接返回 Entity/DO 对象

### Requirement: 参数校验规范

系统 SHALL 所有Controller方法参数必须进行校验。

#### Scenario: 使用@Validated注解

- **WHEN** 在Controller类或方法上
- **THEN** 应使用 `@Validated` 注解启用参数校验

#### Scenario: 使用@Valid注解

- **WHEN** 方法参数为对象类型
- **THEN** 应使用 `@Valid` 或 `@Validated` 注解触发校验

#### Scenario: 使用校验注解

- **WHEN** 定义BO类字段
- **THEN** 应使用 `@NotBlank`、`@Size`、`@Pattern` 等校验注解

### Requirement: 权限校验规范

系统 SHALL 所有API（除登录等公开接口外）必须进行权限校验。

#### Scenario: 使用@SaCheckPermission注解

- **WHEN** 在Controller方法上
- **THEN** 应使用 `@SaCheckPermission("module:resource:action")` 注解进行权限校验

#### Scenario: 忽略权限校验

- **WHEN** 在公开接口（如登录）上
- **THEN** 应使用 `@SaIgnore` 注解忽略权限校验

#### Scenario: 权限标识格式

- **WHEN** 定义权限标识
- **THEN** 应使用 `模块:资源:操作` 格式，如 `materials:project:add`

### Requirement: 分页查询规范

系统 SHALL 分页查询应返回统一的分页数据结构。

#### Scenario: 返回TableDataInfo

- **WHEN** 查询列表数据
- **THEN** 应返回 `TableDataInfo<T>`，包含 `rows`（数据列表）和 `total`（总数）

#### Scenario: 分页参数

- **WHEN** 接收分页参数
- **THEN** 应使用 `pageNum`（页码）和 `pageSize`（每页数量）参数

### Requirement: 对象转换规范

系统 SHALL 必须使用 MapStruct-Plus 进行对象转换。

#### Scenario: Bo转Entity

- **WHEN** 将BO转换为Entity
- **THEN** 应使用 `MapstructUtils.convert(bo, Entity.class)` 方法

#### Scenario: Entity转Vo

- **WHEN** 将Entity转换为VO
- **THEN** 应使用 `MapstructUtils.convert(entity, Vo.class)` 方法

#### Scenario: List<Entity>转List<Vo>

- **WHEN** 将Entity列表转换为VO列表
- **THEN** 应使用 `MapstructUtils.convert(list, Vo.class)` 方法

#### Scenario: 禁止使用BeanUtils

- **WHEN** 需要对象转换
- **THEN** 禁止使用 BeanUtils，必须使用 MapStruct-Plus

### Requirement: 事务控制规范

系统 SHALL 涉及数据修改的方法必须使用事务控制。

#### Scenario: 使用@Transactional注解

- **WHEN** Service层方法涉及数据修改
- **THEN** 应使用 `@Transactional` 注解进行事务控制

#### Scenario: 只读事务

- **WHEN** Service层方法只涉及查询
- **THEN** 应使用 `@Transactional(readOnly = true)` 注解优化性能

### Requirement: 异常处理规范

系统 SHALL 应正确处理异常。

#### Scenario: 使用ServiceException

- **WHEN** 业务逻辑失败
- **THEN** 应抛出 `ServiceException`，如 `throw new ServiceException("用户名已存在")`

#### Scenario: 使用带错误码的ServiceException

- **WHEN** 业务逻辑失败需要指定错误码
- **THEN** 应抛出 `throw new ServiceException(500, "操作失败")`

#### Scenario: 错误码定义

- **WHEN** 定义错误码
- **THEN** 应定义在 `com.hny.common.core.constant.HttpStatus` 类中
- **THEN** 成功：200，失败：500，警告：601

### Requirement: Controller层规范

系统 SHALL Controller层应遵循特定规范。

#### Scenario: 类命名规范

- **WHEN** 创建Controller类
- **THEN** 类名应为 `模块前缀 + 功能描述 + Controller`，如 `MatProjectController`

#### Scenario: 使用@RestController注解

- **WHEN** 定义Controller类
- **THEN** 应使用 `@RestController` 注解

#### Scenario: 使用@RequestMapping注解

- **WHEN** 定义Controller类
- **THEN** 应使用 `@RequestMapping("/module/resource")` 注解指定基础路径

#### Scenario: 使用@RequiredArgsConstructor注解

- **WHEN** 定义Controller类
- **THEN** 应使用 `@RequiredArgsConstructor` 注解进行构造器注入

#### Scenario: 方法命名规范

- **WHEN** 定义Controller方法
- **THEN** 方法名应遵循以下规范：
  - `list`: 查询列表
  - `export`: 导出
  - `getInfo`: 查询详情
  - `add`: 新增
  - `edit`: 修改
  - `remove`: 删除

### Requirement: Service层规范

系统 SHALL Service层应遵循特定规范。

#### Scenario: 接口命名规范

- **WHEN** 创建Service接口
- **THEN** 接口名应为 `I + 模块前缀 + 功能描述 + Service`，如 `IMatProjectService`

#### Scenario: 实现类命名规范

- **WHEN** 创建Service实现类
- **THEN** 类名应为 `模块前缀 + 功能描述 + ServiceImpl`，如 `MatProjectServiceImpl`

#### Scenario: 使用@Service注解

- **WHEN** 定义Service实现类
- **THEN** 应使用 `@Service` 注解

#### Scenario: 使用@RequiredArgsConstructor注解

- **WHEN** 定义Service实现类
- **THEN** 应使用 `@RequiredArgsConstructor` 注解进行构造器注入

### Requirement: Mapper层规范

系统 SHALL Mapper层应遵循特定规范。

#### Scenario: 使用@Mapper注解

- **WHEN** 定义Mapper接口
- **THEN** 应使用 `@Mapper` 注解

#### Scenario: 继承BaseMapperPlus

- **WHEN** 定义Mapper接口
- **THEN** 应继承 `BaseMapperPlus<Entity, Entity>`

#### Scenario: 使用MyBatis-Plus提供的方法

- **WHEN** 实现CRUD操作
- **THEN** 应使用 MyBatis-Plus 提供的方法，不需要手动编写

### Requirement: 禁止在循环中查库

系统 SHALL 禁止在循环中查库。

#### Scenario: 使用批量查询

- **WHEN** 需要查询多条数据
- **THEN** 应使用批量查询或 IN 查询，禁止在循环中逐条查询

### Requirement: 日志规范

系统 SHALL 应正确使用日志记录。

#### Scenario: 日志级别使用场景

- **WHEN** 记录正常业务流程
- **THEN** 应使用 `INFO` 级别，如用户登录、数据查询

#### Scenario: 记录警告信息

- **WHEN** 记录警告信息
- **THEN** 应使用 `WARN` 级别，如参数校验失败、业务规则不满足

#### Scenario: 记录错误信息

- **WHEN** 记录错误信息
- **THEN** 应使用 `ERROR` 级别，如系统异常、数据库错误

### Requirement: 日期时间处理规范

系统 SHALL 应正确处理日期时间。

#### Scenario: VO对象日期字段类型

- **WHEN** 定义VO对象中的日期字段
- **THEN** 应使用 `Date` 或 `LocalDateTime` 类型，禁止使用 `String` 类型

#### Scenario: VO对象必含日期字段

- **WHEN** 定义VO对象
- **THEN** 必须包含 `createTime` 和 `updateTime` 字段（Date 类型）
- **THEN** 必须包含 `createBy` 和 `updateBy` 字段（String 类型）

#### Scenario: 日期序列化格式

- **WHEN** 序列化日期字段
- **THEN** 应使用 `yyyy-MM-dd HH:mm:ss` 格式

#### Scenario: Service层禁止手动转换日期

- **WHEN** 在Service层处理日期
- **THEN** 禁止手动转换日期格式，让 Jackson 自动处理
