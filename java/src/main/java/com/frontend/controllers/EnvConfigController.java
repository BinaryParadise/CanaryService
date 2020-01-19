package com.frontend.controllers;

import com.frontend.domain.*;
import com.frontend.jsonutil.JSON;
import com.frontend.mappers.*;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 环境配置控制器
 */
@Controller
public class EnvConfigController {
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
    @RequestMapping(value = "japi/list", method = RequestMethod.GET)
    @ResponseBody
    public MCResult list(Integer appId, Integer type) {
        Object data = envMapper.findByAppId(appId == null ? 0 : appId, type == null ? -1 : type);
        return MCResult.Success(data);
    }

    @RequestMapping(value = "japi/detail/{id}", method = RequestMethod.GET)
    @ResponseBody
    public MCResult detail(@PathVariable(value = "id") int envid) {
        return MCResult.Success(envMapper.findById(envid));
    }

    /**
     * 添加或更新一个环境
     *
     * @param envid
     * @param config
     * @param author
     * @return
     */
    @RequestMapping(value = "japi/update/{id}", method = RequestMethod.POST)
    @ResponseBody
    @Transactional
    public MCResult update(@PathVariable(value = "id") int envid, @RequestBody MCEnvConfig config, @RequestHeader(name = "X-Login-User") String author) {
        config.setAuthor(author);
        if (envid > 0) {
            //更新环境配置
            return envMapper.update(config) ? MCResult.Success(null) : MCResult.Failed(MybatisError.UpdateFaield);
        } else {
            MCEnvConfig exists = envMapper.findByName(config);
            if (exists != null) {
                return MCResult.Failed(MybatisError.DuplicateEntry);
            }
            config.setAuthor(author);
            List allConfig = envMapper.findByAppId(config.getAppId(), 0);
            if (allConfig == null || allConfig.size() == 0) {
                config.setDefault(true);
            }
            boolean ret = envMapper.insert(config);
            if (ret && config.getCopyid() > 0) {
                //从其它环境复制
                envItemMapper.copyFromEnvId(config.getId(), author, config.getCopyid());
            }
            return ret ? MCResult.Success(null) : MCResult.Failed(MybatisError.InsertFaield);
        }
    }

    @RequestMapping(value = "japi/delete/{id}", method = RequestMethod.POST)
    @ResponseBody
    public MCResult delete(@PathVariable int id) {
        if (id > 0) {
            return envMapper.deleteById(id) ? MCResult.Success() : MCResult.Failed(MybatisError.DeleteFailed);
        }
        return MCResult.Failed(1001, "参数错误");
    }

    /**
     *
     * @param bundleId
     * @param platform
     * @param response
     * @return
     */
    @RequestMapping(value = "conf/env/config", method = RequestMethod.GET, produces = "application/json; charset=utf-8")
    @ResponseBody
    @JSON(type = MCEnvConfig.class, include = "name,type,comment,default,subItems")
    @JSON(type = MCEnvConfigItem.class, include = "name,value,comment")
    @JSON(type = MCSchemeGroup.class, include = "name,comment,subItems,value")
    @JSON(type = MCSchemeItem.class, include = "value,comment")
    public MCResult configs(String bundleId, String platform) {
        return this.configsV2(bundleId, platform, null, null);
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
    @RequestMapping(value = "japi/env/config", method = RequestMethod.GET, produces = "application/json; charset=utf-8")
    @ResponseBody
    @JSON(type = MCEnvConfig.class, include = "name,type,comment,default,subItems")
    @JSON(type = MCEnvConfigItem.class, include = "name,value,comment")
    @JSON(type = MCSchemeGroup.class, include = "name,comment,subItems,value")
    @JSON(type = MCSchemeItem.class, include = "value,comment")
    public MCResult configsV2(String appkey, String os, String bundleId, String platform) {
        appkey = appkey == null ? bundleId : appkey;
        os = os == null ? platform : os;
        if (appkey != null && appkey.length() > 0) {
            List<MCEnvConfigGroup> groups = new ArrayList<>();
            //环境列表
            List<MCEnvConfig> list = envMapper.findByAppKey(appkey);
            //参数列表
            int t;
            if (os != null) {
                t = os.equals("iOS") ? 1 : 2;
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

            List<MCSchemeGroup> schemes = schemeMapper.findByAppKey(appkey);
            for (MCSchemeGroup item : schemes) {
                item.setSubItems(schemeMapper.findByGroupId(item.getId()));
            }
            MCResult result = MCResult.Success(groups);
            result.setExt(schemes);
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
    @RequestMapping(value = "japi/env/schemelist", method = RequestMethod.GET, produces = "application/json; charset=utf-8")
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
