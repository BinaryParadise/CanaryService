package com.frontend.mappers;

import com.frontend.domain.MCMockGroup;
import com.frontend.domain.MCMockInfo;
import com.frontend.domain.MCMockScene;
import com.frontend.models.MCPagination;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface MockMapper {

  List<MCMockGroup> findFullGroup(String appsecret);
  Boolean insertNew(MCMockInfo mock);

  Boolean update(MCMockInfo mock);

  List<MCMockInfo> findAllMock(@Param("appid") Integer appid, @Param("groupid") Integer groupid, @Param("page") MCPagination page);

  List<MCMockGroup> findAllGroup(Integer pid);

  Boolean updateGroup(MCMockGroup group);

  Boolean deleteGroup(MCMockGroup group);

  List<MCMockScene> findAllScene(Integer mockid);
  MCMockScene findScene(Integer sceneid);
  Boolean updateScene(MCMockScene scene);
  Boolean deleteScene(Integer sceneid);
}
