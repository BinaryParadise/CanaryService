package com.frontend.controllers;

import com.frontend.domain.MCAppInfo;
import com.frontend.mappers.ProjectMapper;
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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@RestController
@EnableSwagger2
@Api(tags = "项目管理")
@RequestMapping("/project")
public class ProjectController {
  @Autowired
  private ProjectMapper appsMapper;

  @GetMapping("/list")
  public MCResult projectList(HttpServletRequest request) {
    MCResult result = MCResult.Success(appsMapper.findAll((Integer) request.getAttribute("uid")));
    return result;
  }

  @PostMapping("/update")
  public MCResult update(@RequestBody MCAppInfo project) {
    try {
      if (project.getId() > 0) {
        appsMapper.update(project);
      } else {
        String time = String.valueOf(System.currentTimeMillis());
        project.setIdentify(DigestUtils.md5DigestAsHex(time.getBytes()));
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

  @PostMapping("/appsecret/reset")
  public MCResult reset(@RequestBody MCAppInfo project) {
    try {
      String time = String.valueOf(System.currentTimeMillis());
      String secret = DigestUtils.md5DigestAsHex(time.getBytes());
      project.setIdentify(secret);
      appsMapper.reset(project);
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
  public MCResult delete(@PathVariable("id") Integer pid) {
    return appsMapper.delete(pid) ? MCResult.Success() : MCResult.Failed(MybatisError.UpdateFaield);
  }
}
