# 树形数据后端代码模板

## 标准增删改查后端代码模板（树形结构）

基于Spring Boot + MyBatis-Plus + Sa-Token的树形数据结构后端代码模板，适用于行政区划、组织架构等需要层级关系的场景。

## 文件结构

### 系统管理模块（system）

```
hny-modules/
└── hny-system/
    └── src/main/
        ├── java/com/hny/system/
        │   ├── controller/
        │   │   └── system/
        │   │       └── SysProductController.java   # 控制器
        │   ├── service/
        │   │   ├── ISysProductService.java        # 服务接口
        │   │   └── impl/
        │   │       └── SysProductServiceImpl.java  # 服务实现
        │   ├── domain/
        │   │   ├── SysProduct.java               # 实体类
        │   │   ├── bo/
        │   │   │   └── SysProductBo.java         # 业务对象
        │   │   └── vo/
        │   │       └── SysProductVo.java        # 视图对象
        │   └── mapper/
        │       └── SysProductMapper.java          # Mapper接口
        └── resources/
            └── mapper/system/
                └── SysProductMapper.xml         # MyBatis Mapper XML
```

**说明**：
- 系统管理模块使用 `sys_` 表名前缀，类名使用 `Sys` 前缀
- 包路径为 `com.hny.system`
- 控制器放在 `controller/system/` 目录下
- Mapper XML 放在 `resources/mapper/system/` 目录下

## 1. Controller层模板 (RegionController.java)

```java
package com.hny.system.controller.system;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.hny.system.domain.bo.RegionBo;
import com.hny.system.domain.vo.RegionVo;
import com.hny.system.service.IRegionService;
import com.hny.common.core.domain.R;
import com.hny.common.log.annotation.Log;
import com.hny.common.log.enums.BusinessType;
import com.hny.common.web.core.BaseController;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 行政区划操作处理
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/system/region")
public class RegionController extends BaseController {

    private final IRegionService regionService;

    /**
     * 查询行政区划列表（树形结构）
     */
    @SaCheckPermission("system:region:list")
    @GetMapping("/list")
    public List<RegionVo> list(RegionBo region) {
        return regionService.selectRegionList(region);
    }

    /**
     * 获取行政区划详细信息
     */
    @SaCheckPermission("system:region:query")
    @GetMapping(value = "/{id}")
    public R<RegionVo> getInfo(@PathVariable("id") Long id) {
        return R.ok(regionService.selectRegionById(id));
    }

    /**
     * 新增行政区划
     */
    @SaCheckPermission("system:region:add")
    @Log(title = "行政区划", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated @RequestBody RegionBo region) {
        regionService.insertRegion(region);
        return R.ok();
    }

    /**
     * 修改行政区划
     */
    @SaCheckPermission("system:region:edit")
    @Log(title = "行政区划", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated @RequestBody RegionBo region) {
        regionService.updateRegion(region);
        return R.ok();
    }

    /**
     * 删除行政区划
     */
    @SaCheckPermission("system:region:remove")
    @Log(title = "行政区划", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        regionService.deleteRegionById(id);
        return R.ok();
    }
}
```

## 2. Service接口模板 (IRegionService.java)

```java
package com.hny.system.service;

import com.hny.system.domain.bo.RegionBo;
import com.hny.system.domain.vo.RegionVo;

import java.util.Collection;
import java.util.List;

/**
 * 行政区划 服务层
 */
public interface IRegionService {

    /**
     * 查询行政区划列表（树形结构）
     *
     * @param region 行政区划信息
     * @return 行政区划列表
     */
    List<RegionVo> selectRegionList(RegionBo region);

    /**
     * 查询下级行政区划列表（用于懒加载）
     *
     * @param parentId 父级ID
     * @return 行政区划列表
     */
    List<RegionVo> selectRegionByParentId(Long parentId);

    /**
     * 通过行政区划ID查询行政区划信息
     *
     * @param id 行政区划ID
     * @return 行政区划对象信息
     */
    RegionVo selectRegionById(Long id);

    /**
     * 新增行政区划
     *
     * @param region 行政区划信息
     * @return 结果
     */
    int insertRegion(RegionBo region);

    /**
     * 修改行政区划
     *
     * @param region 行政区划信息
     * @return 结果
     */
    int updateRegion(RegionBo region);

    /**
     * 批量删除行政区划
     *
     * @param ids 需要删除的行政区划ID
     * @return 结果
     */
    int deleteRegionByIds(Collection<Long> ids);

    /**
     * 检查是否存在下级节点
     *
     * @param id 行政区划ID
     * @return 结果
     */
    boolean hasChildByRegionId(Long id);
}
```

## 3. Service实现模板 (RegionServiceImpl.java)

```java
package com.hny.system.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hny.system.domain.Region;
import com.hny.system.domain.bo.RegionBo;
import com.hny.system.domain.vo.RegionVo;
import com.hny.system.mapper.RegionMapper;
import com.hny.system.service.IRegionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 行政区划 服务层实现
 */
@RequiredArgsConstructor
@Service
public class RegionServiceImpl implements IRegionService {

    private final RegionMapper baseMapper;

    @Override
    public List<RegionVo> selectRegionList(RegionBo regionBo) {
        LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Region::getDelFlag, "0");
        if (regionBo != null && regionBo.getFullName() != null && !regionBo.getFullName().isEmpty()) {
            wrapper.like(Region::getFullName, regionBo.getFullName());
        }
        wrapper.orderByAsc(Region::getSortCode);
        List<Region> list = baseMapper.selectList(wrapper);
        List<RegionVo> voList = BeanUtil.copyToList(list, RegionVo.class);
        return buildTree(voList);
    }

    @Override
    public List<RegionVo> selectRegionByParentId(Long parentId) {
        LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Region::getDelFlag, "0")
               .eq(Region::getParentId, parentId)
               .orderByAsc(Region::getSortCode);
        List<Region> list = baseMapper.selectList(wrapper);
        return BeanUtil.copyToList(list, RegionVo.class);
    }

    @Override
    public RegionVo selectRegionById(Long id) {
        Region entity = baseMapper.selectById(id);
        if (entity == null) {
            return null;
        }
        return BeanUtil.toBean(entity, RegionVo.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertRegion(RegionBo regionBo) {
        Region entity = BeanUtil.toBean(regionBo, Region.class);
        // 设置父级路径
        if (regionBo.getParentId() != null && regionBo.getParentId() != 0) {
            Region parent = baseMapper.selectById(regionBo.getParentId());
            if (parent != null && parent.getTreePath() != null) {
                entity.setTreePath(parent.getTreePath() + "," + regionBo.getParentId());
            }
        } else {
            entity.setTreePath("0");
        }
        return baseMapper.insert(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateRegion(RegionBo regionBo) {
        Region entity = BeanUtil.toBean(regionBo, Region.class);
        return baseMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteRegionByIds(Collection<Long> ids) {
        for (Long id : ids) {
            if (hasChildByRegionId(id)) {
                throw new RuntimeException("存在下级数据，无法删除");
            }
        }
        return baseMapper.deleteBatchIds(ids);
    }

    @Override
    public boolean hasChildByRegionId(Long id) {
        LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Region::getParentId, id);
        return baseMapper.selectCount(wrapper) > 0;
    }

    /**
     * 构建树形结构
     */
    private List<RegionVo> buildTree(List<RegionVo> list) {
        List<RegionVo> result = new ArrayList<>();
        Map<Long, List<RegionVo>> map = new HashMap<>();
        // 按parentId分组
        for (RegionVo vo : list) {
            Long parentId = vo.getParentId();
            if (parentId == null) {
                parentId = 0L;
            }
            map.computeIfAbsent(parentId, k -> new ArrayList<>()).add(vo);
        }
        // 构建树
        for (RegionVo vo : list) {
            Long parentId = vo.getParentId();
            if (parentId == null || parentId == 0L) {
                List<RegionVo> children = map.get(vo.getId());
                if (children != null && !children.isEmpty()) {
                    vo.setChildren(children);
                    vo.setHasChildren(true);
                } else {
                    vo.setHasChildren(false);
                }
                vo.setIsLeaf(children == null || children.isEmpty());
                result.add(vo);
            }
        }
        return result;
    }
}
```

> 注意：实际开发中可简化使用，以下为核心要点：
> - 使用 `BeanUtil.toBean()` 或 `BeanUtil.copyToList()` 进行对象转换
> - 使用 `LambdaQueryWrapper` 构建查询条件（推荐）
> - Controller 返回使用 `R.ok()` 而不是 `toAjax()` 或 `toR()`
                updateChildRegionTreePath(region.getId(), region.getParentId());
            }
        }
        return baseMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteRegionByIds(Collection<Long> ids) {
        for (Long id : ids) {
            // 检查是否存在子节点
            if (hasChildByRegionId(id)) {
                throw new RuntimeException("存在下级数据，无法删除");
            }
        }
        return baseMapper.deleteBatchIds(ids);
    }

    @Override
    public boolean hasChildByRegionId(Long id) {
        return baseMapper.hasChildByRegionId(id) > 0;
    }

    /**
     * 构建树形结构
     */
    private List<RegionVo> buildRegionTree(List<RegionVo> list) {
        List<RegionVo> returnList = new ArrayList<>();
        List<Long> tempList = list.stream().map(RegionVo::getId).collect(Collectors.toList());
        for (RegionVo region : list) {
            // 如果是顶级节点
            if (!tempList.contains(region.getParentId()) || "-1".equals(region.getParentId().toString()) || region.getParentId() == 0) {
                recursionFn(list, region);
                returnList.add(region);
            }
        }
        if (returnList.isEmpty()) {
            returnList = list;
        }
        return returnList;
    }

    /**
     * 递归构建树形结构
     */
    private void recursionFn(List<RegionVo> list, RegionVo region) {
        List<RegionVo> childList = getChildList(list, region);
        region.setChildren(childList);
        for (RegionVo child : childList) {
            if (hasChild(list, child)) {
                recursionFn(list, child);
            }
        }
    }

    /**
     * 获取子节点列表
     */
    private List<RegionVo> getChildList(List<RegionVo> list, RegionVo region) {
        List<RegionVo> childList = new ArrayList<>();
        Long parentId = region.getId();
        for (RegionVo child : list) {
            if (child.getParentId() != null && child.getParentId().equals(parentId)) {
                childList.add(child);
            }
        }
        return childList;
    }

    /**
     * 判断是否有子节点
     */
    private boolean hasChild(List<RegionVo> list, RegionVo region) {
        return getChildList(list, region).size() > 0;
    }

    /**
     * 更新子节点的treePath
     */
    private void updateChildRegionTreePath(Long id, Long parentId) {
        Region parent = baseMapper.selectById(parentId);
        String newTreePath = parent != null ? parent.getTreePath() + "," + parentId : "0";

        // 查询所有子节点
        List<Region> children = baseMapper.selectRegionByParentId(id);
        for (Region child : children) {
            String oldTreePath = child.getTreePath();
            String updatedTreePath = newTreePath + oldTreePath.substring(oldTreePath.indexOf(",", 1));
            child.setTreePath(updatedTreePath);
            baseMapper.updateById(child);
            // 递归更新子节点的子节点
            updateChildRegionTreePath(child.getId(), child.getId());
        }
    }
}
```

## 4. Entity实体模板 (Region.java)

```java
package com.hny.system.domain;

import com.baomidou.mybatisplus.annotation.*;
import com.hny.common.tenant.core.TenantEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 行政区划对象 region
 */
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@TableName("sys_region")
public class Region extends TenantEntity {

    /**
     * 主键ID
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 父级ID
     */
    private Long parentId;

    /**
     * 行政区划名称
     */
    private String fullName;

    /**
     * 行政区划编码
     */
    private String enCode;

    /**
     * 排序码
     */
    private Integer sortCode;

    /**
     * 状态（0停用 1正常）
     */
    private Integer enabledMark;

    /**
     * 树形路径
     */
    private String treePath;

    /**
     * 删除标志（0代表存在 2代表删除）
     */
    @TableLogic
    private String delFlag;

    /**
     * 子节点（非数据库字段）
     */
    @TableField(exist = false)
    private List<Region> children;
}
```

## 5. Bo业务对象模板 (RegionBo.java)

```java
package com.hny.system.domain.bo;

import io.github.linpeilie.annotations.AutoMapper;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.hny.common.mybatis.core.domain.BaseEntity;
import com.hny.system.domain.Region;

import java.util.List;

/**
 * 行政区划业务对象 region
 */
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = Region.class, reverseConvertGenerate = false)
public class RegionBo extends BaseEntity {

    /**
     * 主键ID
     */
    private Long id;

    /**
     * 父级ID
     */
    private Long parentId;

    /**
     * 行政区划名称
     */
    @NotBlank(message = "行政区划名称不能为空")
    @Size(max = 100, message = "行政区划名称长度不能超过{max}个字符")
    private String fullName;

    /**
     * 行政区划编码
     */
    @NotBlank(message = "行政区划编码不能为空")
    @Size(max = 50, message = "行政区划编码长度不能超过{max}个字符")
    private String enCode;

    /**
     * 排序码
     */
    private Integer sortCode;

    /**
     * 状态（0停用 1正常）
     */
    private Integer enabledMark;

    /**
     * 树形路径
     */
    private String treePath;

    /**
     * 子节点（非数据库字段）
     */
    private List<Region> children;
}
```

## 6. Vo视图对象模板 (RegionVo.java)

```java
package com.hny.system.domain.vo;

import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 行政区划视图对象 region
 */
@Data
@AutoMapper(target = com.hny.system.domain.Region.class)
public class RegionVo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    private Long id;

    /**
     * 父级ID
     */
    private Long parentId;

    /**
     * 行政区划名称
     */
    private String fullName;

    /**
     * 行政区划编码
     */
    private String enCode;

    /**
     * 排序码
     */
    private Integer sortCode;

    /**
     * 状态（0停用 1正常）
     */
    private Integer enabledMark;

    /**
     * 树形路径
     */
    private String treePath;

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

    /**
     * 子节点
     */
    private List<RegionVo> children;
}
```

## 7. Mapper接口模板 (RegionMapper.java)

```java
package com.hny.system.mapper;

import com.hny.system.domain.Region;
import com.hny.common.mybatis.core.mapper.BaseMapperPlus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 行政区划Mapper接口
 */
@Mapper
public interface RegionMapper extends BaseMapperPlus<Region, Region> {

    /**
     * 查询行政区划列表
     *
     * @param region 行政区划信息
     * @return 行政区划集合
     */
    List<Region> selectRegionList(@Param("region") Region region);

    /**
     * 根据父级ID查询
     *
     * @param parentId 父级ID
     * @return 行政区划集合
     */
    List<Region> selectRegionByParentId(@Param("parentId") Long parentId);

    /**
     * 检查是否存在子节点
     *
     * @param id 行政区划ID
     * @return 数量
     */
    int hasChildByRegionId(@Param("id") Long id);
}
```

## 8. Mapper XML模板 (RegionMapper.xml)

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.hny.system.mapper.RegionMapper">

    <resultMap type="com.hny.system.domain.vo.RegionVo" id="RegionResult">
        <id property="id" column="id"/>
        <result property="parentId" column="parent_id"/>
        <result property="fullName" column="full_name"/>
        <result property="enCode" column="en_code"/>
        <result property="sortCode" column="sort_code"/>
        <result property="enabledMark" column="enabled_mark"/>
        <result property="treePath" column="tree_path"/>
        <result property="createBy" column="create_by"/>
        <result property="createTime" column="create_time"/>
        <result property="updateBy" column="update_by"/>
        <result property="updateTime" column="update_time"/>
        <result property="remark" column="remark"/>
        <result property="tenantId" column="tenant_id"/>
    </resultMap>

    <sql id="selectRegionVo">
        select id, parent_id, full_name, en_code, sort_code, enabled_mark, tree_path, tenant_id, del_flag
        from sys_region
    </sql>

    <select id="selectRegionList" parameterType="com.hny.system.domain.Region" resultMap="RegionResult">
        <include refid="selectRegionVo"/>
        <where>
            del_flag = '0'
            <if test="fullName != null and fullName != ''">
                AND full_name like concat('%', #{fullName}, '%')
            </if>
            <if test="enCode != null and enCode != ''">
                AND en_code = #{enCode}
            </if>
            <if test="enabledMark != null">
                AND enabled_mark = #{enabledMark}
            </if>
        </where>
        order by sort_code asc, create_time desc
    </select>

    <select id="selectRegionByParentId" resultMap="RegionResult">
        <include refid="selectRegionVo"/>
        where del_flag = '0'
        and parent_id = #{parentId}
        order by sort_code asc
    </select>

    <select id="hasChildByRegionId" resultType="int">
        select count(1) from sys_region
        where del_flag = '0'
        and parent_id = #{id}
    </select>

</mapper>
```

### Mapper XML规范

> **重要提示**：本项目使用 MyBatis-Plus，推荐使用 `LambdaQueryWrapper` 在 Service 层构建查询条件。
> 仅在 MyBatis-Plus 无法满足的复杂查询时才使用 XML。

- **文件位置**：`src/main/resources/mapper/system/SysProductMapper.xml`
- **命名空间**：必须与Mapper接口的全限定名一致
- **简化写法**：只定义自定义查询方法，简单的查询使用 Service 层 QueryWrapper

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.hny.system.mapper.SysProductMapper">

    <!-- 只定义自定义查询，简单查询用 Service 层 LambdaQueryWrapper -->
    <select id="selectChildCount" resultType="Long">
        select count(*) from sys_product where del_flag = '0' and parent_id = #{parentId}
    </select>

</mapper>
```

## 模板规范

### 1. Controller层规范

- **返回类型**：
  - 列表：直接返回 `List<Vo>`（树形结构不需要包装R）
  - 详情：`R<Vo>`
  - 增删改：先调用 service 方法，再返回 `R.ok()`

- **无分页**：树形结构不需要分页查询

- **注意**：不要使用 `toR()`、`toAjax()` 等不存在的方法，统一使用 `R.ok()`

### 2. Service层规范

- **核心方法**：
  - `selectRegionList`：查询完整树形列表
  - `selectRegionByParentId`：根据父级ID查询（用于懒加载）
  - `hasChildByRegionId`：检查是否存在子节点（删除时使用）

- **树形构建**：
  - 使用 `buildRegionTree` 方法在前端构建树形结构
  - 或使用数据库递归查询（CTE）构建

### 3. Entity层规范

- **树形字段**：
  - `parentId`：父级ID
  - `treePath`：树形路径，格式：`0,1,2,3`（顶级节点为0）
  - `children`：子节点列表（非数据库字段）

### 4. 数据库表结构规范

```sql
-- ----------------------------
-- Table structure for sys_region
-- ----------------------------
DROP TABLE IF EXISTS "master"."sys_region";
CREATE TABLE "master"."sys_region" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_sys_region'),

  -- 树形字段
  "parent_id" bigint DEFAULT 0,
  "tree_path" varchar(500) DEFAULT '0',

  -- 业务字段
  "full_name" varchar(100) NOT NULL,
  "en_code" varchar(50) NOT NULL,
  "sort_code" int DEFAULT 0,
  "enabled_mark" tinyint DEFAULT 1,

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
COMMENT ON COLUMN "master"."sys_region"."id" IS '主键ID';
COMMENT ON COLUMN "master"."sys_region"."parent_id" IS '父级ID';
COMMENT ON COLUMN "master"."sys_region"."tree_path" IS '树形路径';
COMMENT ON COLUMN "master"."sys_region"."full_name" IS '行政区划名称';
COMMENT ON COLUMN "master"."sys_region"."en_code" IS '行政区划编码';
COMMENT ON COLUMN "master"."sys_region"."sort_code" IS '排序码';
COMMENT ON COLUMN "master"."sys_region"."enabled_mark" IS '状态(0-停用,1-正常)';
COMMENT ON COLUMN "master"."sys_region"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."sys_region"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."sys_region"."create_by" IS '创建者';
COMMENT ON COLUMN "master"."sys_region"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."sys_region"."update_by" IS '更新者';
COMMENT ON COLUMN "master"."sys_region"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."sys_region"."del_flag" IS '删除标志(0-存在,2-删除)';

-- Add table comment
COMMENT ON TABLE "master"."sys_region" IS '行政区划表';

-- Add index
CREATE INDEX idx_sys_region_parent_id ON "master"."sys_region"("parent_id");
CREATE INDEX idx_sys_region_tree_path ON "master"."sys_region"("tree_path");
```

### 5. 树形路径说明

- **顶级节点**：`tree_path = '0'`
- **二级节点**：`tree_path = '0,1'`（父节点ID）
- **三级节点**：`tree_path = '0,1,2'`（父节点ID列表）
- **作用**：
  - 快速查询某个节点的所有子孙节点
  - 快速查询某个节点的所有祖先节点
  - 支持批量删除操作
