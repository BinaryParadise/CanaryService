package com.frontend.controllers;

import com.frontend.domain.MCAppInfo;
import com.frontend.domain.MCMockGroup;
import com.frontend.domain.MCMockInfo;
import com.frontend.mappers.MockMapper;
import com.frontend.models.MCPagination;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;
import org.sqlite.SQLiteErrorCode;
import org.sqlite.SQLiteException;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import javax.servlet.http.HttpServletRequest;
import javax.websocket.server.PathParam;

@RestController
@EnableSwagger2
@Api(tags = "Mock数据")
@RequestMapping("/mock")
public class MockController {
  @Autowired
  private MockMapper mockMapper;

  @GetMapping("/list")
  public MCResult mockList(Integer appid, Integer groupid, Integer pageSize, Integer pageIndex) {
    MCResult result = MCResult.Success(mockMapper.findAllByPage(appid, new MCPagination(pageIndex, pageSize), groupid));
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

}
