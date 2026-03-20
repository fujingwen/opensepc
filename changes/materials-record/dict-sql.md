## 备案证状态字典配置

### 字典类型

| 字段 | 值 |
|------|-----|
| 字典名称 | 备案证状态 |
| 字典类型编码 | certificate_status |

### 字典数据

| 字典标签 | 字典值 | 备注 |
|---------|-------|------|
| 未过期 | 0 | 未过期状态 |
| 已过期 | 1 | 已过期状态 |

### 前端使用

```javascript
const { proxy } = getCurrentInstance()
const { certificate_status } = proxy.useDict('certificate_status')
```

### 后端使用

```java
@Autowired
private RedisCache redisCache;
List<SysDictData> dictList = redisCache.getCacheObject(CacheConstants.SYS_DICT_KEY + "certificate_status");
```
