package com.frontend.mappers;

import com.frontend.domain.MCAppInfo;
import com.frontend.domain.MCMockInfo;
import com.frontend.models.MCPagination;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface MockMapper {
  Boolean insertNew(MCMockInfo mock);
  Boolean update(MCMockInfo mock);

  List<MCMockInfo> findAllByPage(Integer pid, MCPagination page);
}
