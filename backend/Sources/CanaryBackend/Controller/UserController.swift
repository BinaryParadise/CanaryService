//
//  UserController.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import Networking
import PerfectHTTP

class UserController {
    @Mapping(path: "/user/login", method: .post, description: "用户登录")
    var login: RequestHandler = { request, response in
        var args: [Any] = []
        args.append(request.header(.userAgent) ?? "")
              //data.put("token", TokenProccessor.getInstance().makeToken());
        data.put("stamp", Int64(Date.now.timeIntervalSince1970*1000));
              Integer ret = userMapper.login(data);
              if (ret <= 0) {
                return MCResult.Failed(1001, "用户名或密码错误");
              }
              MCUserInfo user = userMapper.findByLogin(data);
              if (user != null) {
                request.getSession().setAttribute("user", user);
              }
              return MCResult.Success(user);
            } catch (Throwable e) {
              e.printStackTrace();
              return MCResult.Failed(MybatisError.NotFoundEntry);
            }
    }
}
