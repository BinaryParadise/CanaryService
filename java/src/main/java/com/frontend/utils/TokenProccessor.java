package com.frontend.utils;

import sun.misc.BASE64Encoder;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class TokenProccessor {
  private TokenProccessor() {
  }

  ;
  private static final TokenProccessor instance = new TokenProccessor();

  public static TokenProccessor getInstance() {
    return instance;
  }

  /**
   * 生成Token
   *
   * @return
   */
  public String makeToken() {
    String token = (System.currentTimeMillis() + new Random().nextInt(999999999)) + "";
    try {
      MessageDigest md = MessageDigest.getInstance("md5");
      byte hash[] = md.digest(token.getBytes());
      StringBuilder hexString = new StringBuilder();
      for (int i = 0; i < hash.length; i++) {
        if ((0xff & hash[i]) < 0x10) {
          hexString.append("0" + Integer.toHexString((0xFF & hash[i])));
        } else {
          hexString.append(Integer.toHexString(0xFF & hash[i]));
        }
      }
      return hexString.toString();
    } catch (NoSuchAlgorithmException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return null;
  }
}
