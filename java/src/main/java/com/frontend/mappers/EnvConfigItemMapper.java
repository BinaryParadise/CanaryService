package com.frontend.mappers;

import com.frontend.domain.MCEnvConfigItem;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface EnvConfigItemMapper {

    boolean insertNew(MCEnvConfigItem item);
    boolean copyFromEnvId(int envid,Integer uid,int copyid);
    boolean update(MCEnvConfigItem item);
    boolean delete(int id);
    List<MCEnvConfigItem> findByEnvId(int envid);
    @Select("select * from RemoveConfigItem where envid=#{envid} and platform in(0,1) order by updateTime desc")
    List<MCEnvConfigItem> findByEnvIdiOS(@Param("envid") int envid);
    @Select("select * from RemoveConfigItem where envid=#{envid} and platform in(0,2) order by updateTime desc")
    List<MCEnvConfigItem> findByEnvIdAndroid(@Param("envid") int envid);
}
