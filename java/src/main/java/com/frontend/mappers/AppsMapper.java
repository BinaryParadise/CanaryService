package com.frontend.mappers;

import com.frontend.domain.MCAppInfo;
import com.frontend.domain.MCLogCondition;
import com.frontend.models.LogMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface AppsMapper {
    @Select("Select * from apps")
    List<MCAppInfo> findAll();

    MCAppInfo findByAppKey(@Param("appKey") String appKey);

    @Select("SELECT * FROM Project where enable=1 order by orderno asc")
    List<MCAppInfo> findAllEnable();
}
