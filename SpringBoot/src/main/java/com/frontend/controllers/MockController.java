package com.frontend.controllers;

import com.frontend.Global;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

@RestController
@RequestMapping("/mock")
public class MockController {
  @Autowired
  private MockMapper mockMapper;

  @GetMapping("/app/whole")
  @ResponseBody
  @JSON(type = MCMockInfo.class, include = "id,name,path,enabled,sceneid,scenes")
  @JSON(type = MCMockScene.class, include = "id,name,params")
  @JSON(type = MCMockParam.class, include = "id,name,value")
  public MCResult appWhole() {
    List<MCMockGroup> groups = mockMapper.findAllGroup(Global.getAppId(), Global.getUser().getId());
    for (MCMockGroup group : groups) {
      List<MCMockInfo> mocks = mockMapper.findAllMock(Global.getUser(), group.getId(), new MCPagination(1, 1000));
      mocks.forEach(m -> {
        m.setScenes(mockMapper.findAllScene(m.getId()));
        m.getScenes().forEach(s -> {
            MCMockParam param = new MCMockParam();
            param.setSceneid(s.getId());
            s.setParams(mockMapper.findAllParam(param));
          }
        );
        MCMockScene scene = new MCMockScene();
        scene.setId(0);
        scene.setName("自动");
        scene.setMockid(m.getId());
        m.getScenes().add(0, scene);
      });
      group.setMocks(mocks);
    }
    return MCResult.Success(groups);
  }

  @GetMapping("/list")
  public MCResult mockList(Integer groupid, Integer pageSize, Integer current) {
    MCResult result = MCResult.Success(mockMapper.findAllMock(Global.getUser(), groupid, new MCPagination(current, pageSize)));
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
      Global.update();
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
      group.setUid(Global.getUser().getId());
      mockMapper.updateGroup(group);
      Global.update();
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
  public MCResult groupList() {
    MCResult result = MCResult.Success(mockMapper.findAllGroup(Global.getAppId(), Global.getUser().getId()));
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

  @PostMapping("/delete/{id}")
  public MCResult deleteMock(@PathVariable("id") Integer id) {
    mockMapper.deleteMock(id);
    return MCResult.Success();
  }

  @RequestMapping(value = "/app/scene/{id}", produces = "application/json; charset=utf-8", method = {RequestMethod.GET, RequestMethod.POST})
  public String appScene(@PathVariable("id") Integer id, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
    MCMockScene scene = mockMapper.findScene(id);
    if (scene == null) {
      return "scene id " + id + " not found.";
    } else {
      response.setHeader("scene_id", scene.getId().toString());
      response.setHeader("scene_name", URLEncoder.encode(scene.getName(), "utf-8"));
      return scene.getResponse();
    }
  }

  @GetMapping("/scene/list")
  public MCResult sceneList(Integer mockid) {
    List<MCMockScene> scenes = mockMapper.findAllScene(mockid);
    for (MCMockScene scene : scenes) {
      MCMockParam param = new MCMockParam();
      param.setSceneid(scene.getId());
      scene.setParams(mockMapper.findAllParam(param));
      if (scene.getParams().size() == 0) {
        scene.getParams().add(param);
      }
    }
    MCResult result = MCResult.Success(scenes);
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

  @PostMapping("/active")
  public MCResult activeMock(@RequestBody MCMockInfo mock) {
    mockMapper.active(mock);
    Global.update();
    return MCResult.Success();
  }

  @PostMapping("/scene/active")
  public MCResult activeScene(@RequestBody MCMockInfo mock) {
    mockMapper.activeScene(mock);
    Global.update();
    return MCResult.Success();
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
      mockMapper.deleteParam(param.getId());
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
