package com.frontend.controllers;

import com.frontend.mappers.EnvConfigItemMapper;
import com.frontend.domain.MCEnvConfigItem;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/**
 * 环境配置控制器
 */
@RestController
@EnableSwagger2
@Api(tags = "远程配置子项", value = "这个是什么呀")
public class RemoteConfigItemController {

  @Autowired
  private EnvConfigItemMapper envItemMapper;

  @RequestMapping(value = "envitem/list", method = RequestMethod.GET)
  @ResponseBody
  public MCResult list(int envid) {
    return MCResult.Success(envItemMapper.findByEnvId(envid));
  }

  @RequestMapping(value = "envitem/update/{id}", method = RequestMethod.POST)
  @ResponseBody
  public MCResult update(@PathVariable int id, @RequestBody MCEnvConfigItem item, @RequestAttribute(name = "uid") int uid) {
    item.setUid(uid);
    if (id > 0) {
      return envItemMapper.update(item) ? MCResult.Success() : MCResult.Failed(MybatisError.UpdateFaield);
    } else {
      return envItemMapper.insertNew(item) ? MCResult.Success() : MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @RequestMapping(value = "envitem/delete/{id}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
  @ResponseBody
  public MCResult delete(@PathVariable(value = "id") int itemid) {
    return envItemMapper.delete(itemid) ? MCResult.Success() : MCResult.Failed(MybatisError.DeleteFailed);
  }
}
