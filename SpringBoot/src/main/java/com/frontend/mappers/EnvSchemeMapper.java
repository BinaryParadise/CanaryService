package com.frontend.mappers;

import com.frontend.domain.MCSchemeGroup;
import com.frontend.domain.MCSchemeItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface EnvSchemeMapper {
    boolean insert(MCSchemeItem item);
    boolean update(MCSchemeItem item);
    boolean insertItem(MCSchemeItem item);
    boolean delete(int recordId);
    boolean deleteItem(int recordId);
    List<MCSchemeGroup> findByAppId(@Param("appId") int appId);
    List<MCSchemeGroup> findByAppKey(@Param("appkey") String appkey);
    List<MCSchemeItem> findByGroupId(@Param("groupid") int groupid);
}
