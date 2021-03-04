package com.frontend.mappers;

import com.alibaba.fastjson.JSONObject;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface HomeMapper {
  Boolean createSnapshot(String identify, String data);
  JSONObject findByIdentify(@Param("identify") String identify);
}
