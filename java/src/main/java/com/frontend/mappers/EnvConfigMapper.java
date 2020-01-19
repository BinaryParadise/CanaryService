package com.frontend.mappers;

import com.frontend.domain.MCEnvConfig;
import com.frontend.domain.MCEnvConfigDetail;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface EnvConfigMapper {
    boolean insert(MCEnvConfig config);
    boolean deleteById(int id);
    boolean update(MCEnvConfig config);

    MCEnvConfig findByName(MCEnvConfig config);

    MCEnvConfig findById(int id);
    List<MCEnvConfigDetail> findByAppId(@Param("appId") int appId, @Param("type") int type);
    List<MCEnvConfigDetail> findByAppIdPage(int appId,Integer pageIndex,Integer pageSize);
    List<MCEnvConfig> findByAppKey(String appkey);
}
