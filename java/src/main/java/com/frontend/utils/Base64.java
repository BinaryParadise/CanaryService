package com.frontend.utils;

import java.io.UnsupportedEncodingException;

public class Base64 {
    /**
     *
     * @param s
     * @return
     */
    public static String getBASE64(String s)
    {
        if (s == null)
        {
            return null;
        }
        try
        {
            return getBASE64(s.getBytes("UTF-8"));
        } catch (UnsupportedEncodingException e)
        {
            e.printStackTrace();
        }
        return null;
    }

    /**
     *
     * @param s
     * @return
     */
    public static String getBASE64(byte[] b)
    {
        byte[] rb = org.apache.commons.codec.binary.Base64.encodeBase64(b);
        if (rb == null)
        {
            return null;
        }
        try
        {
            return new String(rb, "UTF-8");
        } catch (UnsupportedEncodingException e)
        {
            e.printStackTrace();
        }
        return null;
    }

    /**
     *
     * @param s
     * @return
     */
    public static String getFromBASE64(String s)
    {
        if (s == null)
        {
            return null;
        }
        try
        {
            byte[] b = getBytesBASE64(s);
            if (b == null)
            {
                return null;
            }
            return new String(b, "UTF-8");
        } catch (UnsupportedEncodingException e)
        {
            e.printStackTrace();
        }
        return null;
    }

    /**
     *
     * @param s
     * @return
     */
    public static byte[] getBytesBASE64(String s)
    {
        if (s == null)
        {
            return null;
        }
        try
        {
            byte[] b = org.apache.commons.codec.binary.Base64.decodeBase64(s
                    .getBytes("UTF-8"));
            return b;
        } catch (Exception e)
        {
            return null;
        }
    }
}
