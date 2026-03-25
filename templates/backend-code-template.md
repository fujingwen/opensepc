# 后端代码模板

## 标准增删改查后端代码模板

基于Spring Boot + MyBatis-Plus + Sa-Token的标准增删改查后端代码模板，确保与现有系统保持一致的代码风格和架构。

## 文件结构

创建新模块时需要创建以下文件：

### 示例：系统管理模块（sys_前缀）

```
hny-modules/
└── hny-system/
    └── src/main/
        ├── java/com/hny/system/
        │   ├── controller/
        │   │   └── system/
        │   │       └── SysProductController.java      # 控制器
        │   ├── service/
        │   │   ├── ISysProductService.java            # 服务接口
        │   │   └── impl/
        │   │       └── SysProductServiceImpl.java     # 服务实现
        │   ├── domain/
        │   │   ├── SysProduct.java                   # 实体类
        │   │   ├── bo/
        │   │   │   └── SysProductBo.java             # 业务对象
        │   │   └── vo/
        │   │       └── SysProductVo.java             # 视图对象
        │   │       └── SysProductExcelVO.java       # Excel导出VO（可选）
        │   └── mapper/
        │       └── SysProductMapper.java             # Mapper接口
        └── resources/
            └── mapper/system/
                └── SysProductMapper.xml              # MyBatis Mapper XML
```

**命名规范**：
- 系统管理模块：表名 `sys_`，类名 `Sys` 前缀
- 建材管理模块：表名 `mat_`，类名 `Mat` 前缀
- 其他模块：按需命名
- 包路径为 `com.hny.{模块名}`
- Controller 放在 `controller/{模块名}/` 目录
- Mapper XML 放在 `resources/mapper/{模块名}/` 目录

## Maven模块配置

创建新模块时，需要在Maven配置文件中添加模块依赖。

### 0. 创建模块的 pom.xml

在新模块目录下创建 `pom.xml` 文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>com.hny</groupId>
        <artifactId>hny-modules</artifactId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>hny-newmodule</artifactId>

    <description>
        新模块描述
    </description>

    <dependencies>
        <!-- 通用工具-->
        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-core</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-doc</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-mybatis</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-translation</artifactId>
        </dependency>

        <!-- OSS功能模块 -->
        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-oss</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-log</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-excel</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-web</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-satoken</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-tenant</artifactId>
        </dependency>

        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-common-sensitive</artifactId>
        </dependency>

    </dependencies>

</project>
```

### 1. 在父 pom.xml 中添加依赖管理

在 `construction-material-backend/pom.xml` 文件的 `<dependencyManagement>` 部分添加新模块的依赖声明：

```xml
<dependencyManagement>
    <dependencies>
        <!-- 其他依赖... -->

        <!--  新模块  -->
        <dependency>
            <groupId>com.hny</groupId>
            <artifactId>hny-newmodule</artifactId>
            <version>${revision}</version>
        </dependency>

        <!-- 其他依赖... -->
    </dependencies>
</dependencyManagement>
```

### 2. 在 hny-modules/pom.xml 中添加模块

在 `hny-modules/pom.xml` 文件的 `<modules>` 部分添加新模块：

```xml
<modules>
    <module>hny-demo</module>
    <module>hny-generator</module>
    <module>hny-job</module>
    <module>hny-materials</module>
    <module>hny-system</module>
    <module>hny-workflow</module>
    <module>hny-newmodule</module>  <!-- 添加新模块 -->
</modules>
```

### 3. 在 hny-admin/pom.xml 中添加依赖

在 `hny-admin/pom.xml` 文件的 `<dependencies>` 部分添加新模块的依赖：

```xml
<dependencies>
    <!-- 其他依赖... -->

    <dependency>
        <groupId>com.hny</groupId>
        <artifactId>hny-newmodule</artifactId>
    </dependency>

    <!-- 其他依赖... -->
</dependencies>
```

### 注意事项

- 模块名称格式：`hny-{module}`，例如 `hny-base`、`hny-materials`
- 依赖配置中的 `artifactId` 必须与模块名称一致
- 确保模块的 `pom.xml` 文件中正确配置了 `parent` 为 `hny-boot`
- 添加模块后需要重新构建项目（执行 `mvn clean install`）

## 1. Controller层模板 (ResourceController.java)

```java
package com.hny.system.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.hny.system.domain.bo.ResourceBo;
import com.hny.system.domain.vo.ResourceVo;
import com.hny.system.domain.vo.ResourceExcelVO;
import com.hny.system.service.IResourceService;
import com.hny.common.core.domain.R;
import com.hny.common.core.validate.AddGroup;
import com.hny.common.core.validate.EditGroup;
import com.hny.common.excel.utils.ExcelUtil;
import com.hny.common.mybatis.core.page.PageQuery;
import com.hny.common.mybatis.core.page.TableDataInfo;
import com.hny.common.web.core.BaseController;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * 资源信息操作处理
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/module/resource")
public class ResourceController extends BaseController {

    private final IResourceService resourceService;

    /**
     * 查询资源列表
     */
    @SaCheckPermission("module:resource:list")
    @GetMapping("/list")
    public TableDataInfo<ResourceVo> list(ResourceBo resource, PageQuery pageQuery) {
        return resourceService.selectResourcePageList(resource, pageQuery);
    }

    /**
     * 导出资源列表
     */
    @SaCheckPermission("module:resource:query")
    @PostMapping("/export")
    public void export(ResourceBo resource, HttpServletResponse response) {
        List<ResourceVo> list;
        if (resource.getIds() != null && !resource.getIds().isEmpty()) {
            list = resourceService.selectResourceByIds(resource.getIds());
        } else {
            list = resourceService.selectResourceList(resource);
        }
        List<ResourceExcelVO> excelVOList = list.stream().map(item -> {
            ResourceExcelVO vo = new ResourceExcelVO();
            vo.setId(item.getId());
            vo.setField1(item.getField1());
            return vo;
        }).collect(java.util.stream.Collectors.toList());
        ExcelUtil.exportExcel(excelVOList, "资源数据", ResourceExcelVO.class, response);
    }

    /**
     * 获取资源详细信息
     */
    @SaCheckPermission("module:resource:query")
    @GetMapping(value = "/{id}")
    public R<ResourceVo> getInfo(@PathVariable("id") Long id) {
        return R.ok(resourceService.selectResourceById(id));
    }

    /**
     * 新增资源
     */
    @SaCheckPermission("module:resource:add")
    @PostMapping
    public R<Void> add(@Validated(AddGroup.class) @RequestBody ResourceBo resource) {
        return toAjax(resourceService.insertResource(resource));
    }

    /**
     * 修改资源
     */
    @SaCheckPermission("module:resource:edit")
    @PutMapping
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody ResourceBo resource) {
        return toAjax(resourceService.updateResource(resource));
    }

    /**
     * 删除资源
     */
    @SaCheckPermission("module:resource:remove")
    @DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toAjax(resourceService.deleteResourceByIds(Arrays.asList(ids)));
    }
}
```

## 2. Service接口模板 (IResourceService.java)

```java
package com.hny.system.service;

import com.hny.system.domain.bo.ResourceBo;
import com.hny.system.domain.vo.ResourceVo;
import com.hny.common.mybatis.core.page.PageQuery;
import com.hny.common.mybatis.core.page.TableDataInfo;

import java.util.Collection;
import java.util.List;

/**
 * 资源信息 服务层
 */
public interface IResourceService {

    /**
     * 查询资源分页列表
     *
     * @param resource 资源信息
     * @param pageQuery 分页参数
     * @return 资源分页列表
     */
    TableDataInfo<ResourceVo> selectResourcePageList(ResourceBo resource, PageQuery pageQuery);

    /**
     * 查询资源信息集合
     *
     * @param resource 资源信息
     * @return 资源列表
     */
    List<ResourceVo> selectResourceList(ResourceBo resource);

    /**
     * 根据ID列表查询资源
     *
     * @param ids 主键集合
     * @return 资源集合
     */
    List<ResourceVo> selectResourceByIds(List<Long> ids);

    /**
     * 通过资源ID查询资源信息
     *
     * @param id 资源ID
     * @return 资源对象信息
     */
    ResourceVo selectResourceById(Long id);

    /**
     * 新增资源
     *
     * @param resource 资源信息
     * @return 结果
     */
    int insertResource(ResourceBo resource);

    /**
     * 修改资源
     *
     * @param resource 资源信息
     * @return 结果
     */
    int updateResource(ResourceBo resource);

    /**
     * 批量删除资源
     *
     * @param ids 需要删除的资源ID
     * @return 结果
     */
    int deleteResourceByIds(Collection<Long> ids);
}
```

## 3. Service实现模板 (ResourceServiceImpl.java)

```java
package com.hny.system.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hny.system.domain.Resource;
import com.hny.system.domain.bo.ResourceBo;
import com.hny.system.domain.vo.ResourceVo;
import com.hny.system.mapper.ResourceMapper;
import com.hny.system.service.IResourceService;
import com.hny.common.core.utils.MapstructUtils;
import com.hny.common.mybatis.core.page.PageQuery;
import com.hny.common.mybatis.core.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;

/**
 * 资源信息 服务层实现
 */
@RequiredArgsConstructor
@Service
public class ResourceServiceImpl implements IResourceService {

    private final ResourceMapper baseMapper;

    @Override
    public TableDataInfo<ResourceVo> selectResourcePageList(ResourceBo resource, PageQuery pageQuery) {
        Resource entity = MapstructUtils.convert(resource, Resource.class);
        Page<Resource> page = baseMapper.selectPage(pageQuery.build(), buildQueryWrapper(entity));
        List<ResourceVo> voList = MapstructUtils.convert(page.getRecords(), ResourceVo.class);
        TableDataInfo<ResourceVo> tableDataInfo = new TableDataInfo<>();
        tableDataInfo.setCode(200);
        tableDataInfo.setMsg("查询成功");
        tableDataInfo.setRows(voList);
        tableDataInfo.setTotal(page.getTotal());
        return tableDataInfo;
    }

    @Override
    public List<ResourceVo> selectResourceList(ResourceBo resource) {
        Resource entity = MapstructUtils.convert(resource, Resource.class);
        List<Resource> list = baseMapper.selectResourceList(entity);
        return MapstructUtils.convert(list, ResourceVo.class);
    }

    @Override
    public List<ResourceVo> selectResourceByIds(List<Long> ids) {
        List<Resource> list = baseMapper.selectBatchIds(ids);
        return MapstructUtils.convert(list, ResourceVo.class);
    }

    @Override
    public ResourceVo selectResourceById(Long id) {
        Resource resource = baseMapper.selectById(id);
        return MapstructUtils.convert(resource, ResourceVo.class);
    }

    @Override
    public int insertResource(ResourceBo resource) {
        Resource entity = MapstructUtils.convert(resource, Resource.class);
        // 设置删除标志为0（未删除），否则查询时无法查到该记录
        entity.setDelFlag("0");
        return baseMapper.insert(entity);
    }

    @Override
    public int updateResource(ResourceBo resource) {
        Resource entity = MapstructUtils.convert(resource, Resource.class);
        return baseMapper.updateById(entity);
    }

    @Override
    public int deleteResourceByIds(Collection<Long> ids) {
        return baseMapper.deleteBatchIds(ids);
    }

    private com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Resource> buildQueryWrapper(Resource resource) {
        com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Resource> lqw = new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<>();
        lqw.eq(Resource::getDelFlag, "0");
        if (resource.getTenantId() != null && !resource.getTenantId().isEmpty()) {
            lqw.eq(Resource::getTenantId, resource.getTenantId());
        }
        if (resource.getField1() != null && !resource.getField1().isEmpty()) {
            lqw.like(Resource::getField1, resource.getField1());
        }
        lqw.orderByDesc(Resource::getCreateTime);
        return lqw;
    }
}
```

## 4. Entity实体模板 (Resource.java)

```java
package com.hny.system.domain;

import com.baomidou.mybatisplus.annotation.*;
import com.hny.common.tenant.core.TenantEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 资源对象 resource
 */
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@TableName("resource")
public class Resource extends TenantEntity {

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 字段1
     */
    private String field1;

    /**
     * 字段2
     */
    private String field2;

    /**
     * 状态
     */
    private String status;

    /**
     * 删除标志（0代表存在 2代表删除）
     */
    @TableLogic
    private String delFlag;

    /**
     * 导出时选中的ID列表（非数据库字段）
     */
    @TableField(exist = false)
    private List<Long> ids;
}
```

**重要提示**：如果 MyBatis Mapper XML 的 parameterType 使用实体类，且查询条件中使用了只在 Bo 中存在的字段（如范围查询的 Min/Max 字段），需要在实体类中也添加这些字段，并使用 `@TableField(exist = false)` 标注，表示这些字段不映射到数据库列。

**示例**：

```java
/**
 * 采购数量最小值（查询条件）
 */
@TableField(exist = false)
private BigDecimal purchaseQuantityMin;

/**
 * 采购数量最大值（查询条件）
 */
@TableField(exist = false)
private BigDecimal purchaseQuantityMax;

/**
 * 进场时间开始（查询条件）
 */
@TableField(exist = false)
private LocalDate entryTimeStart;

/**
 * 进场时间结束（查询条件）
 */
@TableField(exist = false)
private LocalDate entryTimeEnd;
```

```

## 5. Bo业务对象模板 (ResourceBo.java)

```java
package com.hny.system.domain.bo;

import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.hny.common.mybatis.core.domain.BaseEntity;
import com.hny.system.domain.Resource;

import java.util.List;

/**
 * 资源业务对象 resource
 */
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Resource.class, reverseConvertGenerate = false)
public class ResourceBo extends BaseEntity {

    /**
     * 主键ID
     */
    private Long id;

    /**
     * 字段1
     */
    @Size(max = 200, message = "字段1长度不能超过{max}个字符")
    private String field1;

    /**
     * 字段2
     */
    @Size(max = 100, message = "字段2长度不能超过{max}个字符")
    private String field2;

    /**
     * 状态
     */
    private String status;

    /**
     * 导出时选中的ID列表（非数据库字段）
     */
    private List<Long> ids;
}
```

## 6. Vo视图对象模板 (ResourceVo.java)

**重要提示**：由于实体类继承自 `TenantEntity`，VO 类必须包含以下字段，否则 MapStruct 转换会失败：

- `createTime` - 创建时间
- `updateTime` - 更新时间
- `createBy` - 创建人
- `updateBy` - 更新人
- `tenantId` - 租户编号

```java
package com.hny.system.domain.vo;

import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

/**
 * 资源视图对象 resource
 */
@Data
@AutoMapper(target = com.hny.system.domain.Resource.class)
public class ResourceVo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    private Long id;

    /**
     * 字段1
     */
    private String field1;

    /**
     * 字段2
     */
    private String field2;

    /**
     * 状态
     */
    private String status;

    /**
     * 租户编号
     */
    private String tenantId;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 更新时间
     */
    private Date updateTime;

    /**
     * 创建人
     */
    private String createBy;

    /**
     * 更新人
     */
    private String updateBy;
}
```

## 7. Excel导出VO模板 (ResourceExcelVO.java)（可选）

**注意**：仅在需要导出功能时才需要创建此文件，不是每个实体都必须有。

```java
package com.hny.system.domain.vo;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 资源信息Excel导出VO
 */
@Data
public class ResourceExcelVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @ExcelProperty(value = "主键ID")
    private Long id;

    /**
     * 字段1
     */
    @ExcelProperty(value = "字段1")
    private String field1;

    /**
     * 字段2
     */
    @ExcelProperty(value = "字段2")
    private String field2;

    /**
     * 状态
     */
    @ExcelProperty(value = "状态")
    private String status;

    /**
     * 租户编号
     */
    @ExcelProperty(value = "租户编号")
    private String tenantId;
}
```

## 8. Mapper接口模板 (ResourceMapper.java)

```java
package com.hny.system.mapper;

import com.hny.system.domain.Resource;
import com.hny.common.mybatis.core.mapper.BaseMapperPlus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 资源Mapper接口
 */
@Mapper
public interface ResourceMapper extends BaseMapperPlus<Resource, Resource> {

    /**
     * 查询资源列表
     *
     * @param resource 资源信息
     * @return 资源集合
     */
    List<Resource> selectResourceList(@Param("resource") Resource resource);
}
```

## 9. Mapper XML模板 (ResourceMapper.xml)

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.hny.system.mapper.ResourceMapper">

    <resultMap type="com.hny.system.domain.vo.ResourceVo" id="ResourceResult">
        <id property="id" column="id"/>
        <result property="field1" column="field1"/>
        <result property="field2" column="field2"/>
        <result property="status" column="status"/>
        <result property="createBy" column="create_by"/>
        <result property="createTime" column="create_time"/>
        <result property="updateBy" column="update_by"/>
        <result property="updateTime" column="update_time"/>
        <result property="remark" column="remark"/>
        <result property="tenantId" column="tenant_id"/>
    </resultMap>

    <resultMap type="com.hny.system.domain.vo.ResourceExcelVO" id="ResourceExportResult">
        <id property="id" column="id"/>
        <result property="field1" column="field1"/>
        <result property="field2" column="field2"/>
        <result property="status" column="status"/>
        <result property="createTime" column="create_time"/>
        <result property="remark" column="remark"/>
    </resultMap>

    <sql id="selectResourceVo">
        select id, field1, field2, status, tenant_id, del_flag
        from resource
    </sql>

    <select id="selectResourceList" parameterType="com.hny.system.domain.Resource" resultMap="ResourceResult">
        <include refid="selectResourceVo"/>
        <where>
            del_flag = '0'
            <if test="field1 != null and field1 != ''">
                AND field1 like concat('%', #{field1}, '%')
            </if>
            <if test="field2 != null and field2 != ''">
                AND field2 = #{field2}
            </if>
            <if test="status != null and status != ''">
                AND status = #{status}
            </if>
        </where>
        order by create_time desc
    </select>

</mapper>
```

### Mapper XML规范

- **文件位置**：`src/main/resources/mapper/module/ResourceMapper.xml`
- **命名空间**：必须与Mapper接口的全限定名一致
- **resultMap定义**：
  - `ResourceResult`：用于Vo对象映射
  - `ResourceExportResult`：用于Excel导出VO映射（可选）
- **字段映射**：
  - 使用驼峰命名：`property="field1"` 对应 `column="field1"`
  - 使用下划线转驼峰：`property="createTime"` 对应 `column="create_time"`
- **SQL片段**：
  - 使用 `<sql id="selectResourceVo">` 定义可重用的SQL片段
  - 使用 `<include refid="selectResourceVo"/>` 引用SQL片段

## 模板规范

### 1. Controller层规范

- **注解**：
  - `@Validated`：参数验证
  - `@RequiredArgsConstructor`：Lombok构造器注入
  - `@RestController`：REST控制器
  - `@RequestMapping`：请求路径映射
  - `@SaCheckPermission`：权限验证
  - `@GetMapping/@PostMapping/@PutMapping/@DeleteMapping`：HTTP方法映射

- **方法命名**：
  - `list`：查询列表
  - `export`：导出
  - `getInfo`：查询详情
  - `add`：新增
  - `edit`：修改
  - `remove`：删除

- **返回类型**：
  - 列表：`TableDataInfo<ResourceVo>`
  - 详情：`R<ResourceVo>`
  - 增删改：`R<Void>`
  - 导出：`void`

- **参数类型**：
  - 查询参数：`ResourceBo`
  - 新增/修改：`@RequestBody ResourceBo`

- **权限标识**：
  - 页面权限：`module:resource:list`
  - 查询权限：`module:resource:query`
  - 新增权限：`module:resource:add`
  - 修改权限：`module:resource:edit`
  - 删除权限：`module:resource:remove`

### 2. Service层规范

- **接口命名**：`IResourceService`
- **实现类命名**：`ResourceServiceImpl`
- **注解**：
  - `@RequiredArgsConstructor`：Lombok构造器注入
  - `@Service`：服务层

- **方法命名**：
  - `selectResourcePageList`：分页查询
  - `selectResourceList`：列表查询
  - `selectResourceByIds`：根据ID列表查询
  - `selectResourceById`：根据ID查询
  - `insertResource`：新增
  - `updateResource`：修改
  - `deleteResourceByIds`：批量删除

- **返回类型**：
  - 查询方法：`ResourceVo` 或 `List<ResourceVo>` 或 `TableDataInfo<ResourceVo>`
  - 增删改方法：`int`

- **参数类型**：
  - 查询参数：`ResourceBo`
  - 新增/修改：`ResourceBo`

- **对象转换**：
  - 使用 `MapstructUtils.convert()` 进行 Bo、Entity、Vo 之间的转换
  - `MapstructUtils.convert(bo, Entity.class)`：Bo 转 Entity
  - `MapstructUtils.convert(entity, Vo.class)`：Entity 转 Vo
  - `MapstructUtils.convert(list, Vo.class)`：List<Entity> 转 List<Vo>

### 3. Entity层规范

- **注解**：
  - `@Data`：Lombok生成getter/setter
  - `@NoArgsConstructor`：Lombok生成无参构造器
  - `@EqualsAndHashCode(callSuper = true)`：继承Entity时必须添加
  - `@TableName`：MyBatis-Plus表名映射
  - `@TableId`：主键注解
  - `@TableLogic`：逻辑删除注解

- **继承**：
  - 继承 `TenantEntity`，包含租户相关字段和审计字段

- **字段**：
  - 必须包含 `delFlag` 字段用于逻辑删除
  - 不包含 `ids` 字段（移到 Bo 中）

- **del_flag 字段规范**：
  - 数据库字段名：`del_flag`
  - 字段类型：`char(1)` 或 `integer`
  - 默认值：`0` 或 `'0'`
  - 字段注释：`删除标志(0-存在,1-删除)` 或 `(0-存在,2-删除)`
  - Java 字段名：`delFlag`
  - Java 类型：`String` 或 `Integer`
  - 注解：`@TableLogic`
  - **重要**：新增数据时，必须在 Service 实现类中手动设置 `delFlag = 0`，否则插入的数据 del_flag 为 NULL，导致查询不到

### 4. Bo业务对象规范

- **注解**：
  - `@Data`：Lombok生成getter/setter
  - `@NoArgsConstructor`：Lombok生成无参构造器
  - `@EqualsAndHashCode(callSuper = true)`：继承BaseEntity时必须添加
  - `@AutoMapper(target = Entity.class, reverseConvertGenerate = false)`：自动映射到Entity
  - `@Size`、`@NotBlank`：参数验证注解

- **继承**：
  - 继承 `BaseEntity`，包含审计字段

- **字段**：
  - 包含所有业务字段
  - 包含 `ids` 字段用于批量操作（类型为 `List<Long>`）
  - 添加验证注解确保数据合法性

- **import语句**：
  - 必须导入 `java.util.List`（当使用 `List<Long> ids` 字段时）
  - 必须导入 `jakarta.validation.constraints.*`（当使用验证注解时）
  - 必须导入 `io.github.linpeilie.annotations.AutoMapper`
  - 必须导入 `lombok.*` 相关注解
  - 必须导入 `com.hny.common.mybatis.core.domain.BaseEntity`
  - 必须导入 `com.hny.system.domain.Resource`（实体类）

### 5. Vo视图对象规范

- **注解**：
  - `@Data`：Lombok生成getter/setter
  - `@AutoMapper(target = Entity.class)`：自动映射到Entity
  - `@Serial`：Java序列化版本号
  - `@JsonFormat`：日期时间格式化注解（用于 createTime 和 updateTime 字段）

- **实现**：
  - 实现 `Serializable` 接口
  - 包含需要返回给前端的字段
  - 不继承任何父类
  - 不包含敏感字段

- **时间字段规范**：
  - `createTime` 和 `updateTime` 必须使用 `Date` 类型，不能使用 `String`
  - 必须添加 `@JsonFormat` 注解指定格式
  - 格式：`@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")`
  - 示例：

    ```java
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;

    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date updateTime;
    ```

  - 必须导入 `java.util.Date` 和 `com.fasterxml.jackson.annotation.JsonFormat`
  - 必须包含 `createBy` 和 `updateBy` 字段（String 类型）
  - 返回格式示例：`2026-03-10 17:33:12`

### 6. Excel导出VO规范（可选）

**注意**：仅在需要导出功能时才需要创建此文件，不是每个实体都必须有。

- **注解**：
  - `@Data`：Lombok生成getter/setter
  - `@ExcelProperty`：Excel导出字段注解
  - `@Serial`：Java序列化版本号

- **实现**：
  - 实现 `Serializable` 接口
  - 只包含需要导出的字段
  - 不继承任何父类，避免处理复杂字段

### 7. Mapper层规范

- **注解**：
  - `@Mapper`：MyBatis Mapper注解

- **继承**：
  - 继承 `BaseMapperPlus<Entity, Entity>`

- **方法**：
  - 使用 MyBatis-Plus 提供的方法
  - 特殊查询方法在 XML 中实现

### 8. 导出功能实现规范（可选）

**注意**：仅在需要导出功能时才需要实现此部分。

- **Controller层**：
  - 判断 `ids` 是否为空
  - 如果 `ids` 不为空，调用 `selectResourceByIds` 方法
  - 如果 `ids` 为空，调用 `selectResourceList` 方法
  - 将 Vo 转换为 ExcelVO
  - 使用 `ExcelUtil.exportExcel` 导出

- **Bo层**：
  - 添加 `ids` 字段（类型为 `List<Long>`）

- **Service层**：
  - 添加 `selectResourceByIds(List<Long> ids)` 方法
  - 使用 `baseMapper.selectBatchIds(ids)` 实现
  - 返回 `List<ResourceVo>`

- **ExcelVO层**：
  - 创建专门的 Excel 导出 VO 类
  - 只包含需要导出的字段
  - 避免处理父类的复杂字段

### 9. 查询条件构建规范

- **使用 LambdaQueryWrapper**：
  - 使用 `LambdaQueryWrapper` 构建查询条件
  - 使用方法引用（如 `Resource::getField1`）而不是字符串

- **逻辑删除**：
  - 必须添加 `lqw.eq(Resource::getDelFlag, "0")`

- **租户隔离**：
  - 必须添加租户ID判断

- **模糊查询**：
  - 使用 `like` 方法

- **精确查询**：
  - 使用 `eq` 方法

- **排序**：
  - 使用 `orderByDesc(Resource::getCreateTime)` 按创建时间倒序

### 10. 对象转换规范

- **Bo 转 Entity**：

  ```java
  Resource entity = MapstructUtils.convert(bo, Resource.class);
  ```

- **Entity 转 Vo**：

  ```java
  ResourceVo vo = MapstructUtils.convert(entity, ResourceVo.class);
  ```

- **List<Entity> 转 List<Vo>**：

  ```java
  List<ResourceVo> voList = MapstructUtils.convert(entityList, ResourceVo.class);
  ```

- **分页结果转换**：

  ```java
  Page<Resource> page = baseMapper.selectPage(pageQuery.build(), buildQueryWrapper(entity));
  List<ResourceVo> voList = MapstructUtils.convert(page.getRecords(), ResourceVo.class);
  TableDataInfo<ResourceVo> tableDataInfo = new TableDataInfo<>();
  tableDataInfo.setCode(200);
  tableDataInfo.setMsg("查询成功");
  tableDataInfo.setRows(voList);
  tableDataInfo.setTotal(page.getTotal());
  return tableDataInfo;
  ```

### 11. 验证注解规范

- **常用验证注解**：
  - `@NotBlank`：非空验证（字符串）
  - `@NotNull`：非空验证（对象）
  - `@Size(max = n)`：长度验证
  - `@Email`：邮箱格式验证
  - `@Pattern`：正则表达式验证

- **验证分组**：
  - `@Validated(AddGroup.class)`：新增验证
  - `@Validated(EditGroup.class)`：编辑验证

### 12. 数据库表结构规范

#### 审计字段规范

所有数据库表必须包含以下审计字段：

```sql
CREATE TABLE "master"."resource" (
  -- 业务字段...
  
  -- 审计字段
  "tenant_id" varchar(20),                  -- 租户编号
  "create_dept" bigint,                    -- 创建部门ID
  "create_by" bigint,                      -- 创建者ID
  "create_time" timestamp NOT NULL DEFAULT now(),  -- 创建时间
  "update_by" bigint,                      -- 更新者ID
  "update_time" timestamp NOT NULL DEFAULT now(),  -- 更新时间
  "del_flag" char(1) DEFAULT '0',          -- 删除标志(0-存在,2-删除)
  
  PRIMARY KEY ("id")
);

-- 添加字段注释
COMMENT ON COLUMN "master"."resource"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."resource"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."resource"."create_by" IS '创建者';
COMMENT ON COLUMN "master"."resource"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."resource"."update_by" IS '更新者';
COMMENT ON COLUMN "master"."resource"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."resource"."del_flag" IS '删除标志(0-存在,2-删除)';
```

**注意事项**：

1. **字段类型规范**：
   - `create_dept` 必须使用 `bigint` 类型，不能使用 `varchar`
   - `create_by` 必须使用 `bigint` 类型，不能使用 `varchar`
   - `update_by` 必须使用 `bigint` 类型，不能使用 `varchar`
   - `create_time` 和 `update_time` 使用 `timestamp` 类型
   - `del_flag` 使用 `char(1)` 类型

2. **Java 实体类处理**：
   - 这些审计字段在 Java 实体类中继承自 `BaseEntity`，无需手动添加
   - `create_dept` 字段在 MyBatis-Plus 中通过 `@TableField(fill = FieldFill.INSERT)` 自动填充
   - `create_by`、`create_time` 字段在 MyBatis-Plus 中通过 `@TableField(fill = FieldFill.INSERT)` 自动填充
   - `update_by`、`update_time` 字段在 MyBatis-Plus 中通过 `@TableField(fill = FieldFill.INSERT_UPDATE)` 自动填充

3. **数据库表必须包含这些字段**：
   - 如果数据库表缺少这些字段，会导致 SQL 错误：`column "create_dept" of relation "table_name" does not exist`
   - 必须在创建表时包含这些字段
   - 如果表已创建但缺少字段，需要使用 ALTER TABLE 添加

4. **字段默认值**：
   - `create_time` 默认值：`now()`
   - `update_time` 默认值：`now()`
   - `del_flag` 默认值：`'0'`

5. **字段注释**：
   - 必须为所有审计字段添加注释
   - 注释格式：`字段名(说明)`
   - 示例：`创建部门`、`创建者`、`创建时间`等

#### 数据库表创建模板

```sql
-- ----------------------------
-- Table structure for resource
-- ----------------------------
DROP TABLE IF EXISTS "master"."resource";
CREATE TABLE "master"."resource" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_resource'),
  
  -- 业务字段
  "field1" varchar(200) NOT NULL,
  "field2" varchar(100) NOT NULL,
  "status" varchar(50) NOT NULL,
  
  -- 审计字段
  "tenant_id" varchar(20),
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) DEFAULT '0',
  
  PRIMARY KEY ("id")
);

-- Add column comments
COMMENT ON COLUMN "master"."resource"."id" IS '主键ID';
COMMENT ON COLUMN "master"."resource"."field1" IS '字段1';
COMMENT ON COLUMN "master"."resource"."field2" IS '字段2';
COMMENT ON COLUMN "master"."resource"."status" IS '状态';
COMMENT ON COLUMN "master"."resource"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."resource"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."resource"."create_by" IS '创建者';
COMMENT ON COLUMN "master"."resource"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."resource"."update_by" IS '更新者';
COMMENT ON COLUMN "master"."resource"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."resource"."del_flag" IS '删除标志(0-存在,2-删除)';

-- Add table comment
COMMENT ON TABLE "master"."resource" IS '资源表';
```

#### 数据库迁移脚本模板

如果表已创建但缺少审计字段，使用以下迁移脚本：

```sql
-- ----------------------------
-- Migration: Add audit fields to resource table
-- Date: YYYY-MM-DD
-- Description: Add missing audit fields to resource table
-- ----------------------------

-- Add tenant_id column
ALTER TABLE "master"."resource" ADD COLUMN "tenant_id" varchar(20);

-- Add create_dept column
ALTER TABLE "master"."resource" ADD COLUMN "create_dept" bigint;

-- Fix data types for create_by and update_by (should be bigint instead of varchar)
ALTER TABLE "master"."resource" ALTER COLUMN "create_by" TYPE bigint USING create_by::bigint;
ALTER TABLE "master"."resource" ALTER COLUMN "update_by" TYPE bigint USING update_by::bigint;

-- Add column comments
COMMENT ON COLUMN "master"."resource"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."resource"."create_dept" IS '创建部门';
```

**注意事项**：

- 如果表已存在且 `create_by`、`update_by` 是 `varchar` 类型，需要使用 `ALTER COLUMN ... TYPE bigint` 修改类型
- 使用 `USING column_name::bigint` 确保数据正确转换
- 必须添加字段注释
