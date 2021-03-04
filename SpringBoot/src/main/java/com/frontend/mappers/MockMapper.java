package com.frontend.mappers;

import com.frontend.domain.MCUserInfo;
import com.frontend.mockable.MCMockGroup;
import com.frontend.mockable.MCMockInfo;
import com.frontend.mockable.MCMockParam;
import com.frontend.mockable.MCMockScene;
import com.frontend.models.MCPagination;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface MockMapper {

  Boolean insertNew(MCMockInfo mock);

  Boolean update(MCMockInfo mock);

  Boolean active(MCMockInfo mock);
  Boolean activeScene(MCMockInfo mock);

  MCMockInfo findMock(Integer mockid);
  List<MCMockInfo> findAllMock(@Param("user") MCUserInfo user, @Param("groupid") Integer groupid, @Param("page") MCPagination page);

  List<MCMockGroup> findAllGroup(Integer pid, Integer uid);

  Boolean updateGroup(MCMockGroup group);

  Boolean deleteGroup(MCMockGroup group);
  Boolean deleteMock(@Param("mockid") Integer mockid);

  List<MCMockScene> findAllScene(Integer mockid);
  MCMockScene findScene(Integer sceneid);
  Boolean updateScene(MCMockScene scene);
  Boolean deleteScene(Integer sceneid);

  List<MCMockParam> findAllParam(MCMockParam param);
  Boolean updateParam(MCMockParam param);
  Boolean deleteParam(Integer paramid);
}
