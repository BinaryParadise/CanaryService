package com.frontend.controllers;

import com.frontend.domain.MCSchemeGroup;
import com.frontend.domain.MCSchemeItem;
import com.frontend.mappers.EnvSchemeMapper;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class EnvSchemeController {
  @Autowired
  EnvSchemeMapper schemeMapper;

  @RequestMapping(value = "scheme/list", method = RequestMethod.GET)
  @ResponseBody
  public MCResult list(Integer appId) {
    List<MCSchemeGroup> result = schemeMapper.findByAppId(appId);
    for (MCSchemeGroup item : result) {
      item.setSubItems(schemeMapper.findByGroupId(item.getId()));
    }
    return MCResult.Success(result);
  }

  @RequestMapping(value = "scheme/update/{id}", method = RequestMethod.POST)
  @ResponseBody
  public MCResult update(@PathVariable int id, @RequestBody MCSchemeItem item) {
    boolean ret;
    if (id == 0) {
      ret = schemeMapper.insert(item);
    } else {
      ret = schemeMapper.update(item);
    }
    return ret ? MCResult.Success() : MCResult.Failed(MybatisError.InsertFaield);
  }

  @RequestMapping(value = "scheme/addItem", method = RequestMethod.POST)
  @ResponseBody
  public MCResult addItem(@RequestBody MCSchemeItem item) {
    return schemeMapper.insertItem(item) ? MCResult.Success() : MCResult.Failed(MybatisError.InsertFaield);
  }

  @RequestMapping(value = "scheme/delete/{id}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
  @ResponseBody
  public MCResult delete(@PathVariable(value = "id") int itemid) {
    return schemeMapper.delete(itemid) ? MCResult.Success() : MCResult.Failed(MybatisError.DeleteFailed);
  }

  @RequestMapping(value = "scheme/deleteItem/{id}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
  @ResponseBody
  public MCResult deleteItem(@PathVariable(value = "id") int itemid) {
    return schemeMapper.deleteItem(itemid) ? MCResult.Success() : MCResult.Failed(MybatisError.DeleteFailed);
  }
}
