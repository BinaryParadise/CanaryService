package com.frontend.mappers;

import com.frontend.domain.MCEnvConfig;
import com.frontend.domain.MCEnvConfigDetail;
import com.frontend.models.MCPagination;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface EnvConfigMapper {
  Integer insert(MCEnvConfig config);

  Integer deleteById(Integer id);
  Integer deleteItemByConfigId(Integer id);

  Integer update(MCEnvConfig config);

  MCEnvConfig findById(int id);

  List<MCEnvConfigDetail> findByAppId(int appId, int type);

  List<MCEnvConfigDetail> findByAppIdPage(int appId, int type, MCPagination page);

  List<MCEnvConfig> findByAppKey(String appkey);
}
