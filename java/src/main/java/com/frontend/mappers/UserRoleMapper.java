package com.frontend.mappers;

import com.frontend.domain.MCUserInfo;
import com.frontend.domain.MCUserRole;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface UserRoleMapper {
  Integer insert(MCUserInfo user);

  Integer updateUser(MCUserInfo user);

  Integer isLogin(String token, long timestamp);

  Integer login(Map<String, Object> data);

  MCUserInfo findByLogin(Map<String, Object> data);

  MCUserInfo findByToken(String token, long stamp);

  List<MCUserInfo> findUserList();
  List<MCUserRole> findRoleList();
}
