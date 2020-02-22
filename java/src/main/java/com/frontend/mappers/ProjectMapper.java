package com.frontend.mappers;

import com.frontend.domain.MCAppInfo;
import com.frontend.domain.MCLogCondition;
import com.frontend.models.LogMessage;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface ProjectMapper {

    Boolean insertNew(MCAppInfo project);

    @Delete("DELETE FROM Project where id=#{id}")
    Boolean delete(Integer id);

    Boolean update(MCAppInfo project);

    MCAppInfo findByAppKey(@Param("appKey") String appKey);

    List<MCAppInfo> findAll(Integer uid);
}
