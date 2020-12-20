package com.frontend.controllers;

import com.frontend.mockable.MCMockGroup;
import com.frontend.mockable.MCMockInfo;
import com.frontend.jsonutil.JSON;
import com.frontend.mappers.MockMapper;
import com.frontend.mockable.MCMockParam;
import com.frontend.mockable.MCMockScene;
import com.frontend.models.MCPagination;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.web.bind.annotation.*;
import org.sqlite.SQLiteErrorCode;
import org.sqlite.SQLiteException;

import java.util.List;

@RestController
@RequestMapping("/mock")
public class MockController {
  @Autowired
  private MockMapper mockMapper;

  @GetMapping("/whole")
  @ResponseBody
  @JSON(type = MCMockScene.class, include = "id,name")
  public MCResult whole(String appsecret) {
    if (appsecret == null || appsecret.length() == 0) {
      return MCResult.Failed(MybatisError.ParamFailed);
    }
    List<MCMockGroup> groups = mockMapper.findFullGroup(appsecret);
    for (MCMockGroup group : groups) {
      List<MCMockInfo> mocks = mockMapper.findAllMock(group.getAppid(), group.getId(), new MCPagination(1, 1000));
      mocks.forEach(m -> m.setScenes(mockMapper.findAllScene(m.getId())));
      group.setMocks(mocks);
    }
    return MCResult.Success(groups);
  }

  @GetMapping("/list")
  public MCResult mockList(Integer appid, Integer groupid, Integer pageSize, Integer pageIndex) {
    MCResult result = MCResult.Success(mockMapper.findAllMock(appid, groupid, new MCPagination(pageIndex, pageSize)));
    return result;
  }

  @PostMapping("/update")
  public MCResult update(@RequestBody MCMockInfo mock) {
    try {
      if (mock.getId() == null) {
        mockMapper.insertNew(mock);
      } else {
        mockMapper.update(mock);
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

  @PostMapping("/group/update")
  public MCResult updateGroup(@RequestBody MCMockGroup group) {
    try {
      mockMapper.updateGroup(group);
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @GetMapping("/group/list")
  public MCResult groupList(Integer appid) {
    MCResult result = MCResult.Success(mockMapper.findAllGroup(appid));
    return result;
  }

  @PostMapping("/group/delete")
  public MCResult deleteGroup(@RequestBody MCMockGroup group) {
    try {
      mockMapper.deleteGroup(group);
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @RequestMapping(value = "/app/scene/{id}", produces = "application/json; charset=utf-8", method = {RequestMethod.GET, RequestMethod.POST})
  public String scene(@PathVariable("id") Integer id) {
    MCMockScene scene = mockMapper.findScene(id);
    if (scene == null) {
      return "scene id " + id + " not found.";
    } else {
      return scene.getResponse();
    }
  }

  @GetMapping("/scene/list")
  public MCResult sceneList(Integer mockid) {
    MCResult result = MCResult.Success(mockMapper.findAllScene(mockid));
    return result;
  }

  @PostMapping("/scene/update")
  public MCResult updateScene(@RequestBody MCMockScene scene) {
    try {
      mockMapper.updateScene(scene);
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @PostMapping("/scene/delete")
  public MCResult deleteScene(@RequestBody MCMockScene scene) {
    try {
      mockMapper.deleteScene(scene.getId());
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @GetMapping("/param/list")
  public MCResult paramList(MCMockParam param) {
    MCResult result = MCResult.Success(mockMapper.findAllParam(param));
    return result;
  }

  @PostMapping("/param/update")
  public MCResult paramUpdate(@RequestBody MCMockParam param) {
    try {
      mockMapper.updateParam(param);
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @PostMapping("/param/delete")
  public MCResult paramDelete(@RequestBody MCMockParam param) {
    try {
      mockMapper.deleteScene(param.getId());
      return MCResult.Success();
    } catch (UncategorizedSQLException e) {
      SQLiteException se = (SQLiteException) e.getCause();
      if (se.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_UNIQUE) {
        return MCResult.Failed(MybatisError.DuplicateEntry);
      }
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

}
