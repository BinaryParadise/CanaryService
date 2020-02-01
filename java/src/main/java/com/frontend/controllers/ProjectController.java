package com.frontend.controllers;

import com.frontend.domain.MCAppInfo;
import com.frontend.mappers.ProjectMapper;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import com.frontend.websocket.WCWebSocket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.sqlite.SQLiteErrorCode;
import org.sqlite.SQLiteException;

import java.sql.SQLException;
import java.util.HashMap;

@Controller
public class ProjectController {
  @Autowired
  private ProjectMapper appsMapper;

  @RequestMapping(value = "japi/app/list", produces = "application/json; charset=utf-8")
  @ResponseBody
  public MCResult projectList() {
    MCResult result = MCResult.Success(appsMapper.findAllEnable());
    return result;
  }

  @RequestMapping(value = "japi/app/modify", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
  @ResponseBody
  public MCResult modify(@RequestBody MCAppInfo project) {
    try {
      if (project.getId() > 0) {
        appsMapper.update(project);
      } else {
        appsMapper.insertNew(project);
      }
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @RequestMapping(value = "japi/app/delete/{id}", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
  @ResponseBody
  public MCResult delete(@PathVariable("id") Integer pid) {
    return appsMapper.delete(pid) ? MCResult.Success() : MCResult.Failed(MybatisError.UpdateFaield);
  }
}
