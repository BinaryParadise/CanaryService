package com.frontend.controllers;

import com.frontend.domain.*;
import com.frontend.jsonutil.JSON;
import com.frontend.mappers.EnvConfigItemMapper;
import com.frontend.mappers.EnvConfigMapper;
import com.frontend.mappers.EnvSchemeMapper;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 环境配置控制器
 */
@RestController
@RequestMapping(value = "/conf")
public class RemoteConfigController {
  @Autowired
  EnvConfigMapper envMapper;

  @Autowired
  EnvConfigItemMapper envItemMapper;

  @Autowired
  EnvSchemeMapper schemeMapper;

  /**
   * 环境配置列表
   *
   * @param id
   * @return
   */
  @GetMapping(value = "/list")
  public MCResult list(Integer appId, Integer type, Integer pageSize, Integer pageIndex) {
    if (appId == null) {
      return MCResult.Failed(1, "缺少参数appId");
    }
    Object data = envMapper.findByAppId(appId, type == null ? 0 : type);
//    Object data = envMapper.findByAppIdPage(appId, type == null ? 0 : type, new MCPagination(pageIndex, pageSize));
    return MCResult.Success(data);
  }

  @GetMapping(value = "/detail/{id}")
  public MCResult detail(@PathVariable(value = "id") int envid) {
    return MCResult.Success(envMapper.findById(envid));
  }

  /**
   * 添加或更新一个环境
   *
   * @param envid
   * @param config
   * @return
   */
  @PostMapping(value = "/update/{id}")
  @Transactional
  public MCResult update(@PathVariable(value = "id") int envid, @RequestBody MCEnvConfig config, @RequestAttribute(name = "uid") int uid) {
    config.setUid(uid);
    if (envid > 0) {
      //更新环境配置
      return envMapper.update(config) > 0 ? MCResult.Success(null) : MCResult.Failed(MybatisError.UpdateFaield);
    } else {
      List allConfig = envMapper.findByAppId(config.getAppId(), 0);
      if (allConfig == null || allConfig.size() == 0) {
        config.setDefaultTag(true);
      }
      try {
        boolean ret = envMapper.insert(config) > 0;
        if (ret && config.getCopyid() > 0) {
          //从其它环境复制
          envItemMapper.copyFromEnvId(config.getId(), uid, config.getCopyid());
        }
        return ret ? MCResult.Success(null) : MCResult.Failed(MybatisError.InsertFaield);
      } catch (UncategorizedSQLException e) {
        e.printStackTrace();
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
    }
  }

  @PostMapping(value = "/delete/{id}")
  @ResponseBody
  @Transactional
  public MCResult delete(@PathVariable(value = "id") int id) {
    if (id > 0) {
      Integer ret = envMapper.deleteById(id);
      if (ret > 0) {
        envMapper.deleteItemByConfigId(id);
      }
      return ret > 0? MCResult.Success() : MCResult.Failed(MybatisError.DeleteFailed);
    }
    return MCResult.Failed(1001, "参数错误");
  }

  /**
   * 客户端：获取环境配置列表（包含配置项）
   *
   * @param appkey
   * @param os
   * @param bundleId 兼容旧版
   * @param platform 兼容旧版
   * @return
   */
  @GetMapping(value = "/full")
  @ResponseBody
  @JSON(type = MCEnvConfig.class, include = "id,name,type,comment,defaultTag,subItems")
  @JSON(type = MCEnvConfigItem.class, include = "name,value,comment")
  @JSON(type = MCSchemeGroup.class, include = "name,comment,subItems,value")
  @JSON(type = MCSchemeItem.class, include = "value,comment")
  public MCResult full(String appkey, String platform) {
    if (appkey != null && appkey.length() > 0) {
      List<MCEnvConfigGroup> groups = new ArrayList<>();
      //环境列表
      List<MCEnvConfig> list = envMapper.findByAppKey(appkey);
      //参数列表
      int t;
      if (platform != null) {
        t = platform.equals("iOS") ? 1 : 2;
      } else {
        t = 0;
      }
      list.forEach(conf -> conf.setSubItems(t == 0 ? envItemMapper.findByEnvId(conf.getId()) :
        (t == 1 ? envItemMapper.findByEnvIdiOS(conf.getId()) : envItemMapper.findByEnvIdAndroid(conf.getId()))));
      //按环境类型分组
      for (int i = 0; i < 3; i++) {
        MCEnvConfigGroup group = new MCEnvConfigGroup();
        group.setType(i);
        ArrayList<MCEnvConfig> items = new ArrayList<>();
        for (MCEnvConfig item : list) {
          if (item.getType() == i) {
            items.add(item);
          }
        }
        group.setItems(items);
        groups.add(group);
      }

//      List<MCSchemeGroup> schemes = schemeMapper.findByAppKey(appkey);
//      for (MCSchemeGroup item : schemes) {
//        item.setSubItems(schemeMapper.findByGroupId(item.getId()));
//      }
      MCResult result = MCResult.Success(groups);
//      result.setExt(schemes);
      return result;
    } else {
      return MCResult.Failed(1001, "啊咧，你的参数貌似不对?");
    }
  }

  /**
   * 客户端：获取短链配置列表
   *
   * @param appKey
   * @return
   */
  @GetMapping(value = "/schemelist")
  @ResponseBody
  @JSON(type = MCSchemeGroup.class, include = "name,comment,subItems,value")
  @JSON(type = MCSchemeItem.class, include = "value,comment")
  @JSON(type = MCResult.class, filter = "ext")
  public MCResult schemelist(String appKey, HttpServletResponse response) {
    if (appKey != null && appKey.length() > 0) {
      List<MCSchemeGroup> schemes = schemeMapper.findByAppKey(appKey);
      for (MCSchemeGroup item : schemes) {
        item.setSubItems(schemeMapper.findByGroupId(item.getId()));
      }
      MCResult result = MCResult.Success(schemes);
      return result;
    } else {
      return MCResult.Failed(1001, "啊咧，你的参数貌似不对?");
    }
  }
}
