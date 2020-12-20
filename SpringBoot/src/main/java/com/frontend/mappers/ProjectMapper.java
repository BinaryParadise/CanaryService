package com.frontend.mappers;

import com.frontend.domain.MCAppInfo;
import com.frontend.domain.MCLogCondition;
import com.frontend.models.LogMessage;
import com.frontend.models.MCPagination;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface ProjectMapper {

    Boolean insertNew(MCAppInfo project);

    @Delete("DELETE FROM Project where id=#{id}")
    Boolean delete(Integer id);

    Boolean update(MCAppInfo project);

    Boolean reset(MCAppInfo project);

    List<MCAppInfo> findAll(Integer uid);
}
